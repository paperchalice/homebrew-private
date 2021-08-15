class BoostPropertyTree < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/property_tree/"
  url "https://github.com/boostorg/property_tree.git",
    tag:      "boost-1.77.0",
    revision: "d30ff9404bd6af5cc8922a177865e566f4846b19"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-property-tree-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "58d93fae4ea2da6ccbe2905024bcdd914e74e53c4e0420a239ff0e17502313ef"
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
