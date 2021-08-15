class BoostLockfree < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lockfree/"
  url "https://github.com/boostorg/lockfree.git",
    tag:      "boost-1.77.0",
    revision: "66f66c977038cb8a316bfc242de1843df9302613"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-lockfree-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "eb7f525c783091f392abf0e0af929b8e3826e5dd959fcd474c967ae9dca4dba1"
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
