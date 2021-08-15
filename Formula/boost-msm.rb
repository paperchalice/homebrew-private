class BoostMsm < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/msm/"
  url "https://github.com/boostorg/msm.git",
    tag:      "boost-1.77.0",
    revision: "03f58ead6d0ec23d52e5c7b382e2c98df1d943d5"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-msm-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "3bbf51bab6d323dfe22d85795b6c8b98234f09b2e22cacec53724ee97c1d6ee9"
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
