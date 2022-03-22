class BoostAccumulators < Formula
  desc "Library for incremental statistical computation"
  homepage "https://boost.org/libs/accumulators/"
  url "https://github.com/boostorg/accumulators.git",
    tag:      "boost-1.77.0",
    revision: "14c13370602fe86d134a948943958cab0921ce9c"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-accumulators-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "42a3b13709ef85b159ba67e7cddbb4b8939ce2df42d551e46503a34146c6da08"
  end

  depends_on "boost-circular-buffer"
  depends_on "boost-mp11"
  depends_on "boost-numeric-conversion"
  depends_on "boost-parameter"
  depends_on "boost-range"
  depends_on "boost-serialization"
  depends_on "boost-ublas"

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
