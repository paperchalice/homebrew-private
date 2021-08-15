class BoostAlign < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/align/"
  url "https://github.com/boostorg/align.git",
    tag:      "boost-1.77.0",
    revision: "0790cd45c8e05b1b59fffbc948b6bcb26eb6a2aa"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-align-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "2057b12d571596ddad3808afb897302f986d813984076939b233debc7557ef7a"
  end

  depends_on "boost-assert"
  depends_on "boost-config"
  depends_on "boost-core"
  depends_on "boost-static-assert"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/align.hpp>

      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
