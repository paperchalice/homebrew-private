class QtVirtualKeyboard < Formula
  desc "Qt Quick virtual keyboard"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtvirtualkeyboard-everywhere-src-6.1.1.tar.xz"
  sha256 "246d1acdcd953819b09b1da22bd359335d145d8a3550d9e827dc1fd27b6bd3ff"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-virtual-keyboard-6.1.1"
    sha256 cellar: :any, big_sur: "eb8c226510e4d40ed73bd2a570e2b5d79aa866176141b9bd720e94b453992a2e"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "hunspell"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-svg"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -D FEATURE_myscript=ON
      -D FEATURE_t9write=ON
      -D FEATURE_t9write_alphabetic=ON
      -D FEATURE_t9write_cjk=ON
      -D FEATURE_vkb_arrow_keynavigation=ON
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
