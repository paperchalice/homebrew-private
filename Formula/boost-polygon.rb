class BoostPolygon < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/polygon/"
  url "https://github.com/boostorg/polygon.git",
    tag:      "boost-1.77.0",
    revision: "8ba35b57c1436c4b36f7544aadd78c2b24acc7db"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-polygon-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "14ea1da95f43ac9b6823f6e62b2a25c7970b17680cad2040e9be01254bc4e1b1"
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
