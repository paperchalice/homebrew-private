class BoostEndian < Formula
  desc "Facilities for dealing with endianness"
  homepage "https://boost.org/libs/endian/"
  url "https://github.com/boostorg/endian.git",
    tag:      "boost-1.77.0",
    revision: "14dd63931211782a2169c8146e459afe20f92239"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-endian-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "27315ce407ee268d1a11bac836accb4a7f607c884639c66ae87f102d39a698a0"
  end

  depends_on "boost-core"
  depends_on "boost-type-traits"

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
