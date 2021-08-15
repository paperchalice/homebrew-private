class BoostCircularBuffer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/circular_buffer/"
  url "https://github.com/boostorg/circular_buffer.git",
    tag:      "boost-1.77.0",
    revision: "d4fbf446b903fb6651b56bbd5931a9b902ef962c"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-circular-buffer-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "872d43d85e39dd52d54b002d65d3a1d5c0ba51ea5ecf8ba7566d26a0123caaff"
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
