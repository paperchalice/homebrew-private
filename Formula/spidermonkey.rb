class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/93.0/source/firefox-93.0.source.tar.xz"
  sha256 "a78f080f5849bc284b84299f3540934a12e961a7ea368b592ae6576ea1f97102"
  license "MPL-1.1"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/releasenotes/?["' >]}i)
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.10"   => :build
  depends_on "rust"          => :build

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  def install
    ac_options = %W[
      --prefix=#{prefix}
      --enable-application=js
      --enable-compile-environment
      --enable-optimize
      --enable-smoosh
      --disable-debug
      --with-system-ffi
      --with-system-icu
      --with-system-nspr
    ].map { |arg| "ac_add_options #{arg}" }

    (buildpath/"mozconfig").write <<~EOS
      #{ac_options.join "\n"}
      mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj-opt-@CONFIG_GUESS@
    EOS

    ENV["MOZCONFIG"] = "#{buildpath}/mozconfig"
    ENV["MOZBUILD_STATE_PATH"] = "#{buildpath}/Homebrew_state"
    system "./mach", "create-mach-environment"
    system "./mach", "--no-interactive", "build"
    system "./mach", "install"
  end

  test do
    system "echo"
  end
end
