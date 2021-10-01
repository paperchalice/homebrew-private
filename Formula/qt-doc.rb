class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/single/qt-everywhere-src-6.2.0.tar.xz"
  sha256 "60c2dc0ee86dd338e5c5194bd95922abfc097841e3e855693dfb4f5aaf0db4db"
  license "GFDL-1.3-only"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-doc-6.1.3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "7bbab8a11e59152287fa0b329975d0d84cf077f5c4cef1a88ff244d17f188416"
  end

  depends_on "cmake"      => :build
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build
  depends_on "python"     => :build
  depends_on "qt-tools"   => :build
  depends_on xcode: :build

  def install
    inreplace "qtbase/cmake/FindGSSAPI.cmake", "gssapi_krb5", ""
    inreplace "qtbase/CMakeLists.txt", "FATAL_ERROR", ""

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}
      -sysroot #{MacOS.sdk_path}

      -libexecdir share/qt/libexec
      -plugindir share/qt/plugins
      -qmldir share/qt/qml
      -docdir share/doc/qt

      -no-feature-relocatable
      -system-sqlite
    ]

    system "./configure", *config_args
    system "cmake", "--build", ".", "-t", "qch_docs"
    system "cmake", "--build", ".", "-t", "install_qch_docs"
  end

  def postinstall
    if Formula["qt-tools"].linked?
      Pathname.glob(share/"doc/qt/*.qch") do |qch|
        system "Assistant", "-register", qch
      end
    end
  end

  test do
    assert_predicate share/"doc/qt", :exist?
  end
end
