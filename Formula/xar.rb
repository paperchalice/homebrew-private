class Xar < Formula
  desc "EXtensible ARchiver"
  homepage "https://mackyle.github.io/xar/"
  url "https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz"
  sha256 "ee46089968457cf710b8cf1bdeb98b7ef232eb8a4cdeb34502e1f16ef4d2153e"
  license "BSD-3-Clause"

  depends_on "openssl"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "icu4c"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    inreplace "configure", "OpenSSL_add_all_ciphers ()", "c"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
