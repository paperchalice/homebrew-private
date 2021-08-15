class BoostPool < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/pool/"
  url "https://github.com/boostorg/pool.git",
    tag:      "boost-1.77.0",
    revision: "b516ac5b82571902ced902394b30d38b7d8182f0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-pool-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ac262ea5c80a13fad938708b67eff1b5b100c7a81162a00555f99f2bf2e5f7b7"
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
