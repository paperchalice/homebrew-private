class BoostDll < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/dll/"
  url "https://github.com/boostorg/dll.git",
    tag:      "boost-1.77.0",
    revision: "ac134827f348b33dcdc3814b42cff57c2e792aad"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-dll-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "fcad1d366ef53252ff81836f2bc2b637c41933e386721d0b82bdd329bcd11fc1"
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
