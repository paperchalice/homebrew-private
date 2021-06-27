class IntelLlvm < Formula
  desc "Intel fork"
  homepage "https://github.com/intel/llvm"
  url "https://github.com/intel/llvm.git",
    tag:      "2020-12",
    revision: "5eebd1e4bfce1a921409443a3662a1aeabd4ac6e"
  license "Apache-2.0" => { with: "LLVM-exception" }

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only "same as llvm"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on xcode: :build
  depends_on "python@3.9"

  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    inreplace "opencl-aot/CMakeLists.txt", "v2020.06.16", "v2021.04.29"
    inreplace "sycl/CMakeLists.txt", "v2020.06.16", "v2021.04.29"
    inreplace "buildbot/compile.py", ")]", '), "--verbose"]'
    cd "buildbot" do
      system "python3", "./configure.py", "--no-werror"
      system "python3", "./compile.py"
    end
    system "cmake", "--install", "./build"
    prefix.install Dir["./build/install/*"]
  end

  test do
    system "echo"
  end
end
