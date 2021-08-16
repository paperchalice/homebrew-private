class BoostSmartPtr < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/smart_ptr/"
  url "https://github.com/boostorg/smart_ptr.git",
    tag:      "boost-1.77.0",
    revision: "72221d1da0ada73871ff5e0f8e60fe5ecbd7a296"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-smart-ptr-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "349b06f0e665921942b26c689bd3927b236ebad69063588002b9c52397ba313d"
  end

  depends_on "boost-core"
  depends_on "boost-move"
  depends_on "boost-throw-exception"
  depends_on "boost-type-traits"

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
