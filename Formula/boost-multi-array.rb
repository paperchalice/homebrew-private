class BoostMultiArray < Formula
  desc "Multi dimensions array"
  homepage "https://boost.org/libs/multi_array/"
  url "https://github.com/boostorg/multi_array.git",
    tag:      "boost-1.77.0",
    revision: "0c5348bef71b890c4bd06eff1ee5ebda69e7b27a"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-multi-array-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "c9383fe2bcd7fa93f19e45627a76d699799461986125cd8aebef8970afd7770e"
  end

  depends_on "boost-iterator"

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
