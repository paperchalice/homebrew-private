class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz"
  sha256 "d14d06df4265134ee42c4d50f5a60cb8b471b7b6a47da8e5d914d49dd783794f"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cmake-3.21.3"
    sha256 cellar: :any, big_sur: "8dca26d0290ce2bde55968cdf3de7250c1e8d8d751fdf7de7de48a7d93325189"
  end

  depends_on "kwiml"      => :build
  depends_on "pkgconf"    => :build

  # nghttp2 is for curl
  depends_on "jsoncpp"
  depends_on "libarchive"
  depends_on "libuv"
  depends_on "qt-base"
  depends_on "rhash"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  resource "bootstrap-cmake" do
    url "https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1-macos10.10-universal.tar.gz"
    sha256 "20dbede1d80c1ac80be2966172f8838c3d899951ac4467372f806b386d42ad3c"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    resource("bootstrap-cmake").stage buildpath/"bootstrap-cmake"
    ENV.append_path "PATH", buildpath/"bootstrap-cmake/CMake.app/Contents/bin"

    cmake_args = std_cmake_args(install_prefix: libexec) + %W[
      -D BUILD_QtDialog=ON

      -D CMAKE_DATA_DIR=/share/cmake
      -D CMAKE_DOC_DIR=/share/doc/cmake
      -D CMAKE_MAN_DIR=/share/man

      -D CMAKE_USE_SYSTEM_LIBRARIES=ON

      -D LibArchive_ROOT=#{Formula["libarchive"].prefix}

      -D CMake_INSTALL_EMACS_DIR=#{elisp.to_s.delete_prefix "#{prefix}/"}
      -D CMake_BUILD_LTO=ON

      -S .
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    %w[bin share].each do |p|
      prefix.install libexec/"CMake.app/contents"/p
      (libexec/"CMake.app/Contents/").install_symlink prefix/p
    end
    rm bin/"cmake-gui"
    prefix.write_exec_script libexec/"CMake.app/Contents/MacOS/CMake"
    bin.install prefix/"CMake" => "cmake-gui"
    rm pkgshare/"Modules/Internal/CPack/CPack.OSXScriptLauncher.in"
    (bin/"cmake-app").write <<~SH
      #!/bin/sh
      open #{libexec}/CMake.app
    SH
  end

  def post_install
    if Formula["qt-tools"].linked?
      share.glob("doc/qt/*.qch") do |qch|
        system "Assistant", "-register", qch
      end
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
