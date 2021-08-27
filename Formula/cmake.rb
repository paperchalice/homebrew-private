class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2.tar.gz"
  sha256 "94275e0b61c84bb42710f5320a23c6dcb2c6ee032ae7d2a616f53f68b3d21659"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cmake-3.21.2"
    sha256 cellar: :any, big_sur: "499792b9c3848ceb78200d60158d69a185a4ea6d2239eba181f0e9de52820d7d"
  end

  depends_on "kwiml"      => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  depends_on "jsoncpp"
  depends_on "libarchive"
  depends_on "libuv"
  depends_on "nghttp2"
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
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
