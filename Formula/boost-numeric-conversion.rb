class BoostNumericConversion < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/numeric/conversion/"
  url "https://github.com/boostorg/numeric_conversion.git",
    tag:      "boost-1.77.0",
    revision: "db44689f4f4f74d6572a868e13f523c82fca5a55"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-numeric-conversion-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "988809c4fc576db04bec15faf58833d0da72c6648bb2af445d8b996574bfdf69"
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
