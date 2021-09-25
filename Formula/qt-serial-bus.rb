class QtSerialBus < Formula
  desc "Support for CAN and potentially other serial buses"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/development_releases/qt/6.2/6.2.0-rc2/submodules/qtserialbus-everywhere-src-6.2.0-rc2.tar.xz"
  sha256 "30dce67bd63f8075603877ac63da810b13cfcbc56b6467d0fe4a106e8b85e338"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtserialbus.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-serial-bus-6.2.0-rc2"
    sha256 cellar: :any, big_sur: "67cb58251c982ed9e6a7e54d79e37c23fa9e1a33ff729a796b8e11aeea55d68e"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"
  depends_on "qt-serial-port"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  test do
    system "echo"
  end
end
