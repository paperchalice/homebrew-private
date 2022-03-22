class BoostProto < Formula
  desc "Framework for building Embedded Domain-Specific Languages in C++"
  homepage "https://boost.org/libs/proto/"
  url "https://github.com/boostorg/proto.git",
    tag:      "boost-1.77.0",
    revision: "7f924934689b940f3a72212ab0f714ec6fd6e34b"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-proto-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "4c195b9813cab0cfb3551d5556d2670eebcd0861c82d232450eadade1a560d17"
  end

  depends_on "boost-range"

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
