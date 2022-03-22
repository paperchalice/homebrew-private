class BoostIo < Formula
  desc "Utilities for the standard I/O library"
  homepage "https://boost.org/libs/io/"
  url "https://github.com/boostorg/io.git",
    tag:      "boost-1.77.0",
    revision: "7392d7274c3743e605bf58076566c258617833ed"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-io-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "3e289562c262ca7d591dc7845efbfa0950233aaca9f2cf830472d67cd94c3f66"
  end

  depends_on "boost-config"

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
