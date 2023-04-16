class BoostCmake < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/config/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.82.0/boost-1.82.0.tar.xz"
  sha256 "fd60da30be908eff945735ac7d4d9addc7f7725b1ff6fcdcaede5262d511d21e"
  license "BSL-1.0"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -S .
      -B build
    ]
    system "cmake", *cmake_args
    system "cmake", "-DCMAKE_INSTALL_LOCAL_ONLY=ON", "-P", "build/cmake_install.cmake"
    rm_rf include
  end

  test do
    system "echo"
  end
end
