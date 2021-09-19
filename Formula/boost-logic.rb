class BoostLogic < Formula
  desc "3-state boolean library"
  homepage "https://boost.org/libs/logic/"
  url "https://github.com/boostorg/logic.git",
    tag:      "boost-1.77.0",
    revision: "a5b56ff6fe7368e5f5ebbb374279ddc9fb49a2d5"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-logic-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "2d4280349628c7f983a94b65cca303bb8b19bd74b52ecaf8d82b620a190ae4ce"
  end

  depends_on "boost-core"

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
