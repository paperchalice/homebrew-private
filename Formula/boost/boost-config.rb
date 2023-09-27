class BoostConfig < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/config/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.bz2"
  sha256 "1e19565d82e43bc59209a168f5ac899d3ba471d55c7610c677d4ccf2c9c500c0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-config-1.77.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "e2c1c97d60a0109f8a7b89f0d4c2bc0b759569d65d9ab8a74b21f84af1104c8a"
  end

  resource "config" do
    url "https://github.com/boostorg/config.git",
      tag:      "boost-1.80.0",
      revision: "1cff5e37bb69f42ffab73438de61e34c71258f19"
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-headers", "stage"

    prefix.install "stage/lib"
    (lib.glob "**/boost_headers-config.cmake").each do |f|
      inreplace f, buildpath/"stage", HOMEBREW_PREFIX
    end
    resource("config").stage do
      prefix.install "include"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <boost/config.hpp>
      using namespace std;
      int main() {
        std::cout << BOOST_LIB_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp"
    system "./a.out"
  end
end
