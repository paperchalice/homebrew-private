class BoostCrc < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/crc/"
  url "https://github.com/boostorg/crc.git",
    tag:      "boost-1.77.0",
    revision: "c80e31f78a248e33480ced76c4b03a0b71a5c4db"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-crc-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "4b47a68b1ce27c01156ac747ad1b7403292e471ad4d73d460b531ab1570a952e"
  end

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
