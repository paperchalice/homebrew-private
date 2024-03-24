class Cppdap < Formula
  desc "C++ library for the Debug Adapter Protocol"
  homepage "https://github.com/google/cppdap"
  url "https://github.com/google/cppdap/archive/refs/tags/dap-1.58.0-a.tar.gz"
  sha256 "5d35ca5db78570b6bef698e3365f79bd82a4f78e8393546387f78d7bdb2a2a08"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cppdap-1.58.0"
    sha256 cellar: :any, ventura: "841301c9212f99e00b7e1072ad93b3315142ed97dfb929180f1019b4e47de344"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -D CPPDAP_USE_EXTERNAL_NLOHMANN_JSON_PACKAGE=ON
      -D BUILD_SHARED_LIBS=ON
    ]
    inreplace "CMakeLists.txt", "STATIC", ""

    system "cmake", *cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
