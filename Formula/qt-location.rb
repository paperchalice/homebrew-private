class QtLocation < Formula
  desc "Support for CAN and potentially other serial buses"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtlocation-everywhere-src-6.1.1.tar.xz"
  sha256 "246d1acdcd953819b09b1da22bd359335d145d8a3550d9e827dc1fd27b6bd3ff"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtlocation.git", branch: "dev"

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.basename
    end
  end

  test do
    system "echo"
  end
end
