class BoostRational < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/rational/"
  url "https://github.com/boostorg/rational.git",
    tag:      "boost-1.77.0",
    revision: "564623136417068916495e2b24737054d607347c"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-rational-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "6193a4dadd1ecdbbbd0bd9f07b29712d49cd6cbca6b77ef9ddcc8c8d890d7e48"
  end

  depends_on "boost-integer"
  depends_on "boost-utility"

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
