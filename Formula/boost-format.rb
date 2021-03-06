class BoostFormat < Formula
  desc "Formatting arguments according to a format-string"
  homepage "https://boost.org/libs/format/"
  url "https://github.com/boostorg/format.git",
    tag:      "boost-1.77.0",
    revision: "c1170a6d546b36f9399f3983fad0994e8f946d8f"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-format-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f5ed96583f1f5bbc1291042eb6a0c8b27f225607d4af1177f497b630603ce6fc"
  end

  depends_on "boost-optional"
  depends_on "boost-smart-ptr"
  depends_on "boost-throw-exception"
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
