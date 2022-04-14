class Tradcpp < Formula
  desc "K&R-style C preprocessor"
  homepage "https://www.netbsd.org/~dholland/tradcpp"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.5.3.tar.gz"
  sha256 "e17b9f42cf74b360d5691bc59fb53f37e41581c45b75fcd64bb965e5e2fe4c5e"
  license "BSD-2-Clause"

  depends_on "bmake" => :build

  def install
    system "bmake"
    bin.install "tradcpp"
    man1.install "tradcpp.1"
  end

  test do
    system "echo"
  end
end
