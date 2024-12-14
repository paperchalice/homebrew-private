class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.2/cmake-3.31.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.2.tar.gz"
  sha256 "42abb3f48f37dbd739cdfeb19d3712db0c5935ed5c2aef6c340f9ae9114238a2"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cmake-3.30.1"
    sha256 cellar: :any, ventura: "1682f0451a363dfa9578fe9f39ed221f28870601509a73ee9d7180bb9fccea8e"
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
      -D CMake_INSTALL_EMACS_DIR=#{elisp.relative_path_from prefix}
      -D CMake_BUILD_LTO=ON
    ]

    system "./bootstrap", *bootstrap_args
    system "make"
    system "make", "install"

    libexec.install prefix/"CMake.app"
    %w[bin share].each do |p|
      prefix.install libexec/"CMake.app/contents"/p
      (libexec/"CMake.app/Contents/").install_symlink prefix/p
    end
    rm bin/"cmake-gui"
    prefix.write_exec_script libexec/"CMake.app/Contents/MacOS/CMake"
    bin.install prefix/"CMake" => "cmake-gui"
    (bin/"cmake-app").write <<~SH
      #! /bin/sh
      open #{opt_libexec}/CMake.app
    SH

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
      MacroAddFileDependencies
      TestBigEndian
      TestCXXAcceptsFlag
      UsePkgConfig
      Use_wxWindows
      WriteBasicConfigVersionFile
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
