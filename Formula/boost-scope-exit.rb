class BoostScopeExit < Formula
  desc "C++ RAII technique"
  homepage "https://boost.org/libs/scope_exit/"
  url "https://github.com/boostorg/scope_exit.git",
    tag:      "boost-1.77.0",
    revision: "60baaae454b2da887a31cf939e22015b6263c9e4"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-scope-exit-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "477e2bf3ef81b02faf55c8fd6f67e640860714342647905fd3e3933248c51415"
  end

  depends_on "boost-function"

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
