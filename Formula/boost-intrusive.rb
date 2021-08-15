class BoostIntrusive < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/intrusive/"
  url "https://github.com/boostorg/intrusive.git",
    tag:      "boost-1.77.0",
    revision: "f44b0102b4ee9acf7b0304b3f5b27dde02297202"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-intrusive-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "dbf9fa19aec41c51e6f316f4b96066c19bf452d5c0db95651c560a1f70fe7637"
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
