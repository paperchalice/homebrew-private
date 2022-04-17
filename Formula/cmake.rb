class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.21.4.tar.gz"
  sha256 "998c7ba34778d2dfdb3df8a695469e24b11e2bfa21fbe41b361a3f45e1c9345e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cmake-3.22.0"
    sha256 cellar: :any, big_sur: "b8938b10e09401aff3ce18a61d868f5c98aafeb70bb2594722110d8e6dea42bc"
  end

  depends_on "pkgconf" => :build

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
    mirror "http://fresh-center.net/linux/misc/cmake-3.21.3.tar.gz"
    sha256 "20dbede1d80c1ac80be2966172f8838c3d899951ac4467372f806b386d42ad3c"
  end

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
    (bin/"cmake-app").write <<~SH
      #! /bin/sh
      open #{libexec}/CMake.app
    SH
  end

  def post_install
    qt_tools = Formula["qt-tools"]
    if qt_tools.latest_version_installed?
      share.glob("doc/qt/*.qch") { |qch| system qt_tools.bin/"Assistant", "-register", qch }
    end
    ln_sf libexec/"CMake.app", "/Applications/CMake.app"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
