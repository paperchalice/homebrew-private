class BoostStaticString < Formula
  desc "Dynamically resizable string of characters with compile-time fixed capacity"
  homepage "https://boost.org/libs/static_string/"
  url "https://github.com/boostorg/static_string.git",
    tag:      "boost-1.77.0",
    revision: "6978da552efcf9a4394c747553ea75f53e3af832"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-static-string-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "67dc02ec6fef3f899c0d271213b394269fbdc861eb8d1e5147735d9be7fcf5ab"
  end

  depends_on "boost-container-hash"
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
