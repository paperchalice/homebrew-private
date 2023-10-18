class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/single/qt-everywhere-src-6.3.0.tar.xz"
  sha256 "cd2789cade3e865690f3c18df58ffbff8af74cc5f01faae50634c12eb52dd85b"
  license "GFDL-1.3-only"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-doc-6.3.0"
    sha256 cellar: :any_skip_relocation, monterey: "3a0f52dac2a4b84fefb070b65dbb30d74d8a3f00cbdfc2851ad68efd6704280c"
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
