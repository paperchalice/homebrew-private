class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev/"
  # NOTE: fetch source from here: https://treeherder.mozilla.org/jobs?repo=mozilla-release
  # click on the first SM(pkg) link you see, then navigate to `Artifacts` sheet
  # download the `mozjs-<version>.tar.xz`
  url "https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/RPc3WnqfRfK_CQdBKL8N_g/runs/0/artifacts/public/build/mozjs-78.11.0.tar.bz2"
  version "78.11.0"
  sha256 "935105e1a8a97d64daffb372690e2b566b5f07641f01470929dbbc82d20d4407"
  license "MPL-1.1"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.9"    => :build
  depends_on "rust"          => :build

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"

  def install
    inreplace "build/moz.configure/bindgen.configure", "6.0", ""
    inreplace "build/moz.configure/toolchain.configure",
                "sdk_max_version = Version('10.15.4')",
                "sdk_max_version = Version('11.99')"

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

    cd "js/src"
    mkdir "brew_build" do
      system "../configure", *args
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
