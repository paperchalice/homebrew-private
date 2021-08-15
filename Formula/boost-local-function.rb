class BoostLocalFunction < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/local_function/"
  url "https://github.com/boostorg/local_function.git",
    tag:      "boost-1.77.0",
    revision: "bbe7bf9e997c674195a59f8f628c0cef45c6166c"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-local-function-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "d9fc18ebfc0333dabc40420f943e7d21dc24df8bc481b345b5a8826f0b239829"
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
