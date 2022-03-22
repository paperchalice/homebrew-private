class BoostUnordered < Formula
  desc "C++ map based on balanced binary trees"
  homepage "https://boost.org/libs/unordered/"
  url "https://github.com/boostorg/unordered.git",
    tag:      "boost-1.77.0",
    revision: "c494b3db58344aa60ac362887451776a1c5d56c8"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-unordered-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "3a260f6326a3a946a5fcb62afcd1f0db4070e4c8a6f1124821c9be47f0342ffc"
  end

  depends_on "boost-container"
  depends_on "boost-container-hash"
  depends_on "boost-detail"
  depends_on "boost-smart-ptr"
  depends_on "boost-tuple"

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
