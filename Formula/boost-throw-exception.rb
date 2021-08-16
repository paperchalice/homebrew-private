class BoostThrowException < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/throw_exception/"
  url "https://github.com/boostorg/throw_exception.git",
    tag:      "boost-1.77.0",
    revision: "95e02ea52b8525ecf34dbf1e7fae34af09986b8a"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-throw-exception-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "bf9a21a3766b899b5f9a044e720c57f2b911bb41d221f33815eb840671f3cac6"
  end

  depends_on "boost-assert"
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
