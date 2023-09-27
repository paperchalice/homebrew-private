class BoostVmd < Formula
  desc "Variadic Macro Data library"
  homepage "https://boost.org/libs/vmd/"
  url "https://github.com/boostorg/vmd.git",
    tag:      "boost-1.77.0",
    revision: "34cad2c1a574d445812c7c2432d3a5a5c843b412"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-vmd-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "50dcb2c2ed040b30110192fc8b1f818fbfb8100020874742aabc475969656917"
  end

  depends_on "boost-preprocessor"

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
