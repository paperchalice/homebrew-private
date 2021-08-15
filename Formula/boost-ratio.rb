class BoostRatio < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/ratio/"
  url "https://github.com/boostorg/ratio.git",
    tag:      "boost-1.77.0",
    revision: "00073b7d5896603b2036a334253dc9784285355c"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-ratio-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "44b3b3c79476bd70ed21ae38e7937ff72c2ab83d17281fb6975cb87058127c66"
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
