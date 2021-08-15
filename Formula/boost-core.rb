class BoostCore < Formula
  desc "Collection of core utilities"
  homepage "https://boost.org/libs/core/"
  url "https://github.com/boostorg/core.git",
    tag:      "boost-1.77.0",
    revision: "f4b3d5dba6f86caaf96e45901655a954b2ff68b4"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-core-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f555800aec628fd1c6cff6f66ada092202d42d8c8158b07bccf799570adf9578"
  end

  depends_on "boost-config"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/core/addressof.hpp>
      int main() {
        char c = 0;
        boost::addressof(c);
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
