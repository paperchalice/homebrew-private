class QtApplicationManager < Formula
  desc "Qt component for application lifecycle management"
  homepage "https://www.qt.io/"
  url "https://code.qt.io/qt/qtapplicationmanager.git",
    tag:      "v6.4.0",
    revision: "16f1f093feacb15480cf474b833ac3ab88248e6e"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-3.0-only",
  ]

  depends_on "qt-declarative"
  depends_on "qt-multimedia"
  depends_on "qt-remote-objects"
  depends_on "qt-tools"

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
