class Kwiml < Formula
  desc "Kitware Information Macro Library"
  homepage "https://gitlab.kitware.com/utils/kwiml"
  url "https://gitlab.kitware.com/utils/kwiml.git"
  version "2021-04-01"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/kwiml-2021-04-01"
    sha256 cellar: :any_skip_relocation, big_sur: "6faf76a8a7abed49dfd50c0c6d2bb35d80add76d923caab2dc6c43c2148d896a"
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
