class Openmp < Formula
  desc "LLVM OpenMP implementation"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/llvm-project-16.0.0.src.tar.xz"
  sha256 "9a56d906a2c81f16f06efc493a646d497c53c2f4f28f0cb1f3c8da7f74350254"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "llvm" => :build

  depends_on "hwloc"

  def install
    cmake_args = std_cmake_args(install_prefix: lib/"clang/#{version.major}") +%w[
      LIBOMP_INSTALL_ALIASES=OFF
      LIBOMP_FORTRAN_MODULES=ON
      LIBOMP_USE_HWLOC=ON
      LIBOMP_USE_HIER_SCHED=ON
    ].map { |o| "-D #{o}" } + %w[
      -S openmp
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"

    (lib/"clang/#{version.major}").install include
  end

  test do
    system "echo"
  end
end
