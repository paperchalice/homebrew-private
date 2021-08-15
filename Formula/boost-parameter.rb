class BoostParameter < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/parameter/"
  url "https://github.com/boostorg/parameter.git",
    tag:      "boost-1.77.0",
    revision: "94bfc0544a5c4b959d018814f25c54e796020578"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-parameter-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "52918c748bbaafdada35a957091dc9cc8f33fb97ec176c48e1397596b8422b5d"
  end

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
