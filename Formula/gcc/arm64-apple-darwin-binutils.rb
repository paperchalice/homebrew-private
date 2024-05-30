class Arm64AppleDarwinBinutils < Formula
  desc "GNU Binutils for apple silicon cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/arm64-apple-darwin-binutils-2.42"
    sha256 ventura: "f65597c4f9718b231ea5e3439b0d1a554467947e1cb927dde52310206df1a927"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    target = "arm64-apple-darwin#{OS.kernel_version.major}"
    system "./configure", "--target=#{target}",
           "--prefix=#{prefix}",
           "--libdir=#{lib}/#{target}",
           "--with-system-zlib",
           "--with-zstd",
           "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
