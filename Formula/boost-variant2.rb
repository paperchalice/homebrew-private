class BoostVariant2 < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/variant2/"
  url "https://github.com/boostorg/variant2.git",
    tag:      "boost-1.77.0",
    revision: "4153a535a0fa8eb4d18abc262fcf2ae834601261"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-variant2-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "6b48e76d944422c32562bfd337099b50bc3b512aedb486834e960985346d7bdf"
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
