class BoostSignals2 < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/signals2/"
  url "https://github.com/boostorg/signals2.git",
    tag:      "boost-1.77.0",
    revision: "4a51d6e47230123d413cbecb19eb94f195301b8e"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-signals2-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1b05ef0253dec7913f73f8cfb1c93e8a86d3467f8a8541035424264b057b6969"
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
