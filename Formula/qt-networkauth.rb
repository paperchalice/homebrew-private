class QtNetworkauth < Formula
  desc "Qt network authentication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.3/submodules/qtnetworkauth-everywhere-src-6.1.3.tar.xz"
  sha256 "62f6f473eaf5e4e62e153b14bbcfcc18b49e3a431897b4ac69491b5842c72862"
  license "GPL-3.0-only"
  head "https://code.qt.io/qt/qtnetworkauth.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-networkauth-6.1.2"
    sha256 cellar: :any, big_sur: "bf7eaa44bcc513ca9e8721722df1b7a06a444766563a2944afd5596a360b8679"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "qt-base"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Network NetworkAuth REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Network Qt6::NetworkAuth)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtNetworkAuth>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        auto p = new QOAuthHttpServerReplyHandler();
        return 0;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
  end
end
