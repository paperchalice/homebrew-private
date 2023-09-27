class QtInterfaceFramework < Formula
  desc "Qt Interface Definition Language support"
  homepage "https://www.qt.io/"
  url "https://code.qt.io/qt/qtinterfaceframework.git",
    tag:      "v6.4.0",
    revision: "	2c2299e4840ab98c06f31912adc73114639b5a9c"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    "LGPL-3.0-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]

  depends_on "qt-declarative"
  depends_on "qt-multimedia"
  depends_on "qt-remote-objects"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

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
