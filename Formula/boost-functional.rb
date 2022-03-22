class BoostFunctional < Formula
  desc "Enhancements to the function object adapters"
  homepage "https://boost.org/libs/functional/"
  url "https://github.com/boostorg/functional.git",
    tag:      "boost-1.77.0",
    revision: "0c7697fc661cc0879dd55db63b3d44725a71b400"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-functional-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "d3536643bdb8412b8861dec3be408882b95c8dddf30403b8dcfd4e5aba9fd689"
  end

  depends_on "boost-function"

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
