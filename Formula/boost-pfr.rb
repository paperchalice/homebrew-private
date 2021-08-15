class BoostPfr < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/pfr/"
  url "https://github.com/boostorg/pfr.git",
    tag:      "boost-1.77.0",
    revision: "da12b52759ea52c3e2341690f208fea898643bbb"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-pfr-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "985b4da437b291cc6f7f32ffc347db9b370a03ade2a051755d28f6c64e0a1ee2"
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
