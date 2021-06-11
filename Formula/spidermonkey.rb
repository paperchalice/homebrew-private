class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev/"
  url "https://ftp.mozilla.org/pub/firefox/releases/89.0/source/firefox-89.0.source.tar.xz"
  sha256 "db43d7d5796455051a5b847f6daa3423393803c9288c8b6d7f1186f5e2e0a90a"
  license "MPL-1.1"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  livecheck do
    url "https://ftp.mozilla.org/pub/firefox/releases/"
    regex(/(\d+(?:\.\d+)+)/i)
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.9"    => :build
  depends_on "rust"          => :build

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"

  def install
    inreplace "config/rules.mk",
              "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

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
    mkdir "obj" do
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
