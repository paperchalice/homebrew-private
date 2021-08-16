class BoostBind < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/bind/"
  url "https://github.com/boostorg/bind.git",
    tag:      "boost-1.77.0",
    revision: "34a3ee580c88d623c6bc9fe91460ef414dabfbe6"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-bind-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "28f48a9f57fbb5129dc1a2af2baea7093a2fc69c8691fe37643fed955a729707"
  end

  depends_on "boost-core"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/bind.hpp>
      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
