class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.2/cmake-3.31.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.2.tar.gz"
  sha256 "42abb3f48f37dbd739cdfeb19d3712db0c5935ed5c2aef6c340f9ae9114238a2"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cmake-3.31.2"
    rebuild 1
    sha256 cellar: :any, ventura: "d2878b1ba385296f05c642aab890608b4e8e58af13cfce376109f7070b1cbe0c"
  end

  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build

  # nghttp2 is for curl
  depends_on "cppdap"
  depends_on "expat"
  depends_on "jsoncpp"
  depends_on "libarchive"
  depends_on "libuv"
  depends_on "qt-base"
  depends_on "rhash"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  patch do
    url "https://github.com/paperchalice/CMake/commit/b5f9c129dfad77ef4adfaccaf414ee5e728a91c7.patch?full_index=1"
    sha256 "e053a8e808948f963016612b37a9f9fa823924076094c4b87fe064518b6a14d5"
  end

  def install
    bootstrap_args = %W[
      --prefix=#{prefix}
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man

      --system-libs
      --qt-gui

      --
      -D CMAKE_USE_SYSTEM_LIBRARIES=ON
      -D CMake_ENABLE_DRIVER=ON
      -D CMake_INSTALL_EMACS_DIR=#{elisp.relative_path_from prefix}
      -D CMake_BUILD_LTO=ON
    ]

    system "./bootstrap", *bootstrap_args
    system "make"
    cp "./bin/CMake.app/Contents/MacOS/CMake", "./bin/cmake"
    ENV.append_path "PATH", Pathname.pwd/"bin"
    system "make", "install"

    libexec.install prefix/"CMake.app"
    %w[bin share].each do |p|
      prefix.install libexec/"CMake.app/Contents"/p
      (libexec/"CMake.app/Contents/").install_symlink prefix/p
    end
    bin.write_exec_script opt_libexec/"CMake.app/Contents/MacOS/cmake-gui"
    rm libexec/"CMake.app/Contents/MacOS/cmake-driver"
    rm libexec/"CMake.app/Contents/MacOS/cmake-gui"
    (libexec/"CMake.app/Contents/MacOS/cmake-gui").write <<~SH
      #! /bin/sh
      exec #{opt_bin}/cmake-driver --mode=cmake-gui
    SH
    (bin/"cmake-app").write <<~SH
      #! /bin/sh
      open #{opt_libexec}/CMake.app
    SH

    # TODO: MacroAddFileDependencies, after GetPrerequisites
    %w[
      AddFileDependencies
      CMakeDetermineVSServicePack
      CMakeExpandImportedTargets
      CMakeFindFrameworks
      CMakeForceCompiler
      CMakeParseArguments
      Dart
      Documentation
      GetPrerequisites
      TestBigEndian
      TestCXXAcceptsFlag
      UsePkgConfig
      Use_wxWindows
      WriteCompilerDetectionHeader

      FindBoost
      FindCUDA
      FindDart
      FindPythonInterp
      FindPythonLibs
      FindQt
      FindUnixCommands
      FindwxWindows
    ].each { |m| rm pkgshare/"Modules/#{m}.cmake" }
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version})

      project(Template
              VERSION      0.0.0.0
              DESCRIPTION  "CMake template project"
              HOMEPAGE_URL https://www.example.com/
              LANGUAGES    C CXX)

      set(CMAKE_C_STANDARD 17)
      set(CMAKE_CXX_STANDARD 17)
    CMAKE
    system bin/"cmake", "."
  end
end
