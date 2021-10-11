class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.2.0-src/pyside-setup-opensource-src-6.2.0.tar.xz"
  sha256 "fed210b662129955332d2609a900b5b8643130134e4682371b26a9ba60740d01"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "clang"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "echo"
  end
end
