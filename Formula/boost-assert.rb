class BoostAssert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/assert/"
  url "https://github.com/boostorg/assert.git",
    tag:      "boost-1.77.0",
    revision: "6aabfebae6d4acf996fe711de4e9b444ad88c17d"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-assert-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "fb2403bddc077f46112f8711be031784a87bb7d55c0a0adf00d81f62321b6432"
  end

  depends_on "boost-config"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/assert.hpp>
      #include <boost/assert/source_location.hpp>
      int main() {
        BOOST_ASSERT(0 == 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp"
    system "./a.out"
  end
end
