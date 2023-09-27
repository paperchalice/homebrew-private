class BoostSort < Formula
  desc "Sort algorithms collection"
  homepage "https://boost.org/libs/sort/"
  url "https://github.com/boostorg/sort.git",
    tag:      "boost-1.77.0",
    revision: "72a3ae870c59980dadd757f5f63e6be16ab61c1b"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-sort-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "04a56f6c18207c7758ba1ce270376df3c051d3563be5e366bdd458e9d3b93797"
  end

  depends_on "boost-range"

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
