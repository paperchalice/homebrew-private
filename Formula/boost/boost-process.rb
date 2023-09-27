class BoostProcess < Formula
  desc "Comfortable management of processes"
  homepage "https://boost.org/libs/process/"
  url "https://github.com/boostorg/process.git",
    tag:      "boost-1.77.0",
    revision: "b2a96a3e139ae42ea2bcb80cc58f108494a995c5"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-process-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "191ec53727b95153c6e99d3330983819b4800312e055d92a5724aea0427cea4c"
  end

  depends_on "boost-asio"
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
