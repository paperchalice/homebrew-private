class Cppdap < Formula
  desc "C++ library for the Debug Adapter Protocol"
  homepage "https://github.com/google/cppdap"
  url "https://github.com/google/cppdap/archive/c69444ed76f7468b232ac4f989cb8f2bdc100185.tar.gz"
  version "1.65.0"
  sha256 "f73953fe9c9557b6ce893a3ee90bbde5919c96e4f3603d67cdf8ed49da714529"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cppdap-1.65.0"
    sha256 cellar: :any, ventura: "5592b92060106b3d5fc9f906105d0e2df709e7c6c371c2c8db174284dc2e7073"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -D CPPDAP_USE_EXTERNAL_NLOHMANN_JSON_PACKAGE=ON
      -D BUILD_SHARED_LIBS=ON
      -S .
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "echo"
  end
end
