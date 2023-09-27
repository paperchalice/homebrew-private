class BoostFunction < Formula
  desc "Function object wrappers"
  homepage "https://boost.org/libs/function/"
  url "https://github.com/boostorg/function.git",
    tag:      "boost-1.77.0",
    revision: "6d98696d74e1cfbdbe502695cc6b3539b4d4acc9"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-function-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "3e4423276f4e6b1dc8c43bb9e02927f454d1fde7a7b4d40324fd273582abf348"
  end

  depends_on "boost-bind"
  depends_on "boost-throw-exception"
  depends_on "boost-typeof"

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
