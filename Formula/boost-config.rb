class BoostConfig < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/config/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-config-1.77.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "e2c1c97d60a0109f8a7b89f0d4c2bc0b759569d65d9ab8a74b21f84af1104c8a"
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-headers", "stage"

    prefix.install "stage/lib"
    prefix.install "libs/config/include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/version.hpp>
      #include <iostream>
      int main() {
        std::cout << BOOST_LIB_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp"
    system "./a.out"
  end
end
