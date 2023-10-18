class QtSerialBus < Formula
  desc "Support for CAN and potentially other serial buses"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtserialbus-everywhere-src-6.3.0.tar.xz"
  sha256 "d2f6c988cb36e76956b8828cdc17513c0677b5523f635fc30a920701bb3627d6"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtserialbus.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-serial-bus-6.3.0"
    sha256 cellar: :any, monterey: "f736af17d5e3851b685a4eab5b4ef2e924b898d885363dfcd7456d3d999e7afc"
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
