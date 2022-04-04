class Autosp < Formula
  desc "Preprocessor that generates note-spacing commands for MusiXTeX scores"
  homepage "https://ctan.org/pkg/autosp"
  url "http://mirrors.ctan.org/support/autosp/source/autosp-2021-01-07.tar.gz"
  sha256 "beed5784a9a6463d0c49dbf2ef45e5050fb1d5e6cbb372b58357a58b2c385391"
  license "GPL-2.0-or-later"

  def install
    system "./configure", std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
