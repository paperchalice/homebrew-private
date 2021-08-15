class BoostBimap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/bimap/"
  url "https://github.com/boostorg/bimap.git",
    tag:      "boost-1.77.0",
    revision: "85f0f02537d71794a415ef4b992629b2edebfbff"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-bimap-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1883128aa29710f3726bb84e45143682a629a4e4f270a8725f0817c3b93cdb27"
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
