class BoostStatechart < Formula
  desc "C++ library for finite state machines"
  homepage "https://boost.org/libs/statechart/"
  url "https://github.com/boostorg/statechart.git",
    tag:      "boost-1.77.0",
    revision: "586445b824c5cf0e7e6ce4ff2df620fda5d0f0d7"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-statechart-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "800a20acf0dbf4b7f07f23c365d1509b08361b49c5cd4c0276dc5d7a05fd96f8"
  end

  depends_on "boost-conversion"
  depends_on "boost-function"
  depends_on "boost-mpl"
  depends_on "boost-thread"

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
