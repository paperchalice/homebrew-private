class Kwiml < Formula
  desc "Kitware Information Macro Library"
  homepage "https://gitlab.kitware.com/utils/kwiml"
  url "https://gitlab.kitware.com/utils/kwiml.git"
  version "2021-04-01"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + %w[
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
