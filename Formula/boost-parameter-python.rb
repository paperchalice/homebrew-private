class BoostParameterPython < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/parameter_python/"
  url "https://github.com/boostorg/parameter_python.git",
    tag:      "boost-1.77.0",
    revision: "787d8d38d9fd49c34a757b20361f8042dd5ac820"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-parameter-python-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "e49ea432fc694163728eff35bea165ce1bbb7322e749c1e26847395ee1ad322f"
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
