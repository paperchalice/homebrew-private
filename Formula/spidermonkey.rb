class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev/"
  url "https://firefoxci.taskcluster-artifacts.net/d0_mA8vTSm2vbnKjkn-_jQ/0/public/build/mozjs-78.11.0.tar.bz2"
  sha256 "5ad54ac2b0368b9748e08756658eb988d65e5bb088d91baf43267486bcbf1d26"
  license "MPL-1.1"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  livecheck do
    url "https://ftp.mozilla.org/pub/firefox/releases/"
    regex(/\d+\.\d+\.\d+(?=esr)/i)
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.9"    => :build
  depends_on "rust"          => :build

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"

  conflicts_with "narwhal", because: "both install a js binary"

  def install
    inreplace "build/moz.configure/toolchain.configure",
                "sdk_max_version = Version('10.15.4')",
                "sdk_max_version = Version('11.99')"
    inreplace "config/rules.mk",
              "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-shared-js
        --disable-jemalloc
        --with-intl-api
        --with-system-icu
        --with-system-nspr
        --with-system-zlib
      ]

      system "../js/src/configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
  end
end
