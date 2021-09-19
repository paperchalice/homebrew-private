class BoostVariant < Formula
  desc "Safe, generic, stack-based discriminated union container"
  homepage "https://boost.org/libs/variant/"
  url "https://github.com/boostorg/variant.git",
    tag:      "boost-1.77.0",
    revision: "89424892447ed252ebd4232ce6ebb664e58d71ba"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-variant-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ec94e8180a54a5af97593ea121ecd7905fdd64136ed2eade77a331363a9fa13e"
  end

  depends_on "boost-bind"
  depends_on "boost-mpl"
  depends_on "boost-type-index"
  depends_on "boost-utility"

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
