class BoostFusion < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/fusion/"
  url "https://github.com/boostorg/fusion.git",
    tag:      "boost-1.77.0",
    revision: "500e4c120ff2f2414ec225a2a42eb1a665c79956"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-fusion-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "8c406b8ec2f146685479c975669beacd3daac4f3f86107156c216290a47c0c5d"
  end

  depends_on "boost-function-types"
  depends_on "boost-container-hash"
  depends_on "boost-tuple"
  depends_on "boost-typeof"
  depends_on "boost-utility"

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
