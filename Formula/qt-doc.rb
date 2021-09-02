class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.3/single/qt-everywhere-src-6.1.3.tar.xz"
  sha256 "552342a81fa76967656b0301233b4b586d36967fad5cd110765347aebe07413c"
  license "GFDL-1.3-only"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-doc-6.1.2"
    sha256 cellar: :any_skip_relocation, big_sur: "4828eea4445773639946e40541b605a5d30eeabb0530b9e69521b9f46357ad39"
  end

  depends_on "cmake"      => :build
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build
  depends_on "python"     => :build
  depends_on "qt-tools"   => :build

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
