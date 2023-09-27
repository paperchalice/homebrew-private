class BoostAssert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/assert/"
  url "https://github.com/boostorg/assert.git",
    tag:      "boost-1.80.0",
    revision: "7dea14cf7f21dcd5bc5d4cedfd22935878634cdf"
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
      int main() {
        BOOST_ASSERT(0 == 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp"
    system "./a.out"
  end
end
