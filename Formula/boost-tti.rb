class BoostTti < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/tti/"
  url "https://github.com/boostorg/tti.git",
    tag:      "boost-1.77.0",
    revision: "03734c54a51b6372ac3296d2fe5103b7360bcd3f"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-tti-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "c2e98e39874bc84e3b939b017673ebfc33ed66f1fa4437f05739227a073b3723"
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
