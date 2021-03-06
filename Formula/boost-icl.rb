class BoostIcl < Formula
  desc "Interval Container Library"
  homepage "https://boost.org/libs/icl/"
  url "https://github.com/boostorg/icl.git",
    tag:      "boost-1.77.0",
    revision: "e6c06ddee1e2320f11c4ec5cd2661c4abe9bca53"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-icl-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "fffe1fc84914fe017118e8e5f3ab42697671b927fe61d38686c1f57cf8e1dd34"
  end

  depends_on "boost-date-time"

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
