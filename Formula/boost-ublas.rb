class BoostUblas < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/numeric/ublas/"
  url "https://github.com/boostorg/ublas.git",
    tag:      "boost-1.77.0",
    revision: "f0e55caf310d5e01c7e9f2190b2422e113ddeedb"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-ublas-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "8b54c7c277bbedd6f8ef15d243f38c1d73d9b6b63f8e85ac8f46179c94f6eb60"
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
