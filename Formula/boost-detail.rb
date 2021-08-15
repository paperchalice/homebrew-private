class BoostDetail < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/detail/"
  url "https://github.com/boostorg/detail.git",
    tag:      "boost-1.77.0",
    revision: "a01fe6d57b906edf0400daebfb5ea88bb4582f44"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-detail-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "8f661886848d0cff042a8a3c50cf714fb2c60b2fb2cbdb6e78956b1ec1547989"
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
