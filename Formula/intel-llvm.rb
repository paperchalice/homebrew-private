class IntelLlvm < Formula
  desc "Intel staging area for llvm"
  homepage "https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/dpc-compiler.html"
  url "https://github.com/intel/llvm.git",
    tag:      "sycl-nightly/20210716",
    revision: "f7aa2bf3677e61c883e69fe0912eefeea0e1fc45"

  depends_on "cmake"  => [:build, :test]
  depends_on "ninja"  => :build
  depends_on "python" => :build

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    inreplace "opencl/CMakeLists.txt", /(?<=OCL_HEADERS_TAG )[0-9a-f]+/,
      "1bb9ec797d14abed6167e3a3d66ede25a702a5c7"
    inreplace "opencl/CMakeLists.txt", /(?<=OCL_LOADER_TAG )[0-9a-f]+/,
      "4e65bd5db0a0a87637fddc081a70d537fc2a9e70"
    inreplace "sycl/plugins/opencl/CMakeLists.txt", "-Wl,--version-script=${linker_script}", "-w"

    external_projects = %w[
      sycl
      llvm-spirv
      opencl
      libdevice
      xpti
      xptifw
    ]

    cmake_args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLVM_TARGETS_TO_BUILD=host
      -DLLVM_EXTERNAL_PROJECTS=#{external_projects.join ";"}
      -DLLVM_ENABLE_PROJECTS=clang;libcxx;libcxxabi;#{external_projects.join ";"}
      -DLLVM_EXTERNAL_SYCL_SOURCE_DIR=#{buildpath}/sycl
      -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=#{buildpath}/llvm-spirv
      -DLLVM_EXTERNAL_XPTI_SOURCE_DIR=#{buildpath}/xpti
      -DXPTI_SOURCE_DIR=#{buildpath}/xpti
      -DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR=#{buildpath}/xptifw
      -DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=#{buildpath}/libdevice
      -DSYCL_BUILD_PI_ESIMD_CPU=ON
      -DLLVM_BUILD_TOOLS=ON
      -DSYCL_ENABLE_WERROR=OFF
      -DSYCL_INCLUDE_TESTS=OFF

      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_ENABLE_Z3_SOLVER=OFF
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DDEFAULT_SYSROOT=#{MacOS.sdk_path}
      -DPACKAGE_VENDOR=#{tap.user}
      -DBUG_REPORT_URL=#{tap.issues_url}
      -DCLANG_VENDOR_UTI=org.#{tap.user.downcase}.clang

      -G Ninja
      -S llvm
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
