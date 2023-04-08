class QtSerialPort < Formula
  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtserialport-everywhere-src-6.5.0.tar.xz"
  sha256 "9209a9f5978a4adf3a150582270432fe3b635d05513ad1a57bff5ca4954a4dff"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-serial-port-6.3.0"
    sha256 cellar: :any, monterey: "490af1483b2c8f29e1294bab96073d61dc9094a7429a17c4d938a598fb65d7ac"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build
  depends_on "pkgconf" => :build

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
