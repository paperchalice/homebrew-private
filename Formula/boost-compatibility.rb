class BoostCompatibility < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/compatibility/"
  url "https://github.com/boostorg/compatibility.git",
    tag:      "boost-1.77.0",
    revision: "47ce71af6b018764c9ba74c0bfcb4f3151b81aa7"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-compatibility-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "29f23d7b71933638a94587c12658429586f7606af0500f273f7b52e183f3a0e9"
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
