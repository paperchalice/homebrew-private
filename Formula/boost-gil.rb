class BoostGil < Formula
  desc "Generic Image Library"
  homepage "https://boost.org/libs/gil/"
  url "https://github.com/boostorg/gil.git",
    tag:      "boost-1.77.0",
    revision: "e3e779cc69af4905e4910c06f7e9417c2563e362"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-gil-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "6b97585572e9c111aaa9175a933eb992b6876d52b7e3da36dc79d58375c768a5"
  end

  depends_on "boost-polygon"
  depends_on "boost-qvm"
  depends_on "boost-range"
  depends_on "boost-tokenizer"
  depends_on "boost-variant"

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
