class BoostQvm < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/qvm/"
  url "https://github.com/boostorg/qvm.git",
    tag:      "boost-1.77.0",
    revision: "cdc1a96133ef1db9405e0f5a27f4aa9213d627b4"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-qvm-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "6dfdfb21b1b944e126a9f84b4d1efe47f99158dba528166d7c4b49e816b7df86"
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
