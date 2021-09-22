class BoostGeometry < Formula
  desc "Generic Geometry Library"
  homepage "https://boost.org/libs/geometry/"
  url "https://github.com/boostorg/geometry.git",
    tag:      "boost-1.77.0",
    revision: "e2a0b14491e6af904882602ce1c47a0d74ad05a2"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-geometry-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "5ad1eaf5e27b6454b97ed38257dd26028fc0a13edb621aae0d841a0b62de03bc"
  end

  depends_on "boost-filesystem"

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
