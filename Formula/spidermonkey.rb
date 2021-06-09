class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev/"
  url "https://archive.mozilla.org/pub/firefox/releases/78.11.0esr/source/firefox-78.11.0esr.source.tar.xz"
  version "78.11.0"
  sha256 "38394b5937be3839104b3a097d71987c06392d4d8be0d3004182f1d1fbfc577e"
  license "MPL-1.1"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  livecheck do
    url "https://ftp.mozilla.org/pub/firefox/releases/"
    regex(/\d+\.\d+\.\d+(?=esr)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/spidermonkey-78.11.0"
    sha256 cellar: :any, big_sur: "f662cce4a98381387b6d47f33e744b8921089190bb9a19c424f6e5a7e3758572"
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.9"    => :build
  depends_on "rust"          => :build

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"

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
      rm lib/"libjs_static.ajs"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
  end
end
