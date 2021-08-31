class Kwiml < Formula
  desc "Kitware Information Macro Library"
  homepage "https://gitlab.kitware.com/utils/kwiml"
  url "https://gitlab.kitware.com/utils/kwiml.git"
  version "2021-08-20"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/kwiml-2021-08-20"
    sha256 cellar: :any_skip_relocation, big_sur: "66ce1aabdba9093841542a28299f380df515224fe39d19ab5eebc6e64d00c5ec"
  end

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
