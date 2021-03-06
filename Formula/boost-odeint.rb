class BoostOdeint < Formula
  desc "Highly flexible library for solving ordinary differential equations"
  homepage "https://boost.org/libs/numeric/odeint/"
  url "https://github.com/boostorg/odeint.git",
    tag:      "boost-1.77.0",
    revision: "db8f91a51da630957d6bfa1ff87be760b0be97a6"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-odeint-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "7ff5f64d7af6313037f0c2d457df382eff9aabeda639bc8c7850e6ec8c415341"
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
