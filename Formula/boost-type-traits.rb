class BoostTypeTraits < Formula
  desc "Set of very specific traits classes"
  homepage "https://boost.org/libs/type_traits/"
  url "https://github.com/boostorg/type_traits.git",
    tag:      "boost-1.77.0",
    revision: "bfce306637e2a58af4b7bbc881a919dafb7d195b"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-type-traits-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1e7f7c1326c586fc970ae4efd7712a711d361485c6476eda81fdc6ea0a1e2b80"
  end

  depends_on "boost-config"
  depends_on "boost-static-assert"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/type_traits.hpp>
      int main() {
        static_assert(boost::is_array<int[5]>::value == true);
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
