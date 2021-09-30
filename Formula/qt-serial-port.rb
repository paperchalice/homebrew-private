class QtSerialPort < Formula
  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qtserialport-everywhere-src-6.2.0.tar.xz"
  sha256 "3fb3c0c37602e6fee8c5e386b61d14f4d7a820cf9e053c6952ad6e860ce05248"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-serial-port-6.2.0"
    sha256 cellar: :any, big_sur: "9283be8449705c69b415d1a4124cdeef027ac54248b717345751c7b086464689"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"

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
