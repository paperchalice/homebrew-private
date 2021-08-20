class BoostLambda < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lambda/"
  url "https://github.com/boostorg/lambda.git",
    tag:      "boost-1.77.0",
    revision: "4007043b545d3a834abaeaf141bb7dbd88c975cc"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-lambda-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "25e8fb0d1f3091e0fd588e18b131d8246fd2dff7e984779c5a8a962952916ad6"
  end

  depends_on "boost-bind"
  depends_on "boost-iterator"

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
