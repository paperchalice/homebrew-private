class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.0/single/qt-everywhere-src-6.1.0.tar.xz"
  sha256 "326a710b08b0973bb4f5306a786548d8b8dd656db75ce9f3f85ea32680d3c88a"
  license "GFDL-1.3-only"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-doc-6.1.0"
    sha256 cellar: :any_skip_relocation, big_sur: "fcc30183ecd875c476392394cc5b7c59dcbd52cb74b5840b7506fd7d1fe3d20a"
  end

  depends_on "cmake"      => :build
  depends_on "llvm"       => :build
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
      -translationdir share/qt/translations
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -no-feature-relocatable
      -system-sqlite
    ]

    # TODO: remove `-DFEATURE_qt3d_system_assimp=ON`
    # and `-DTEST_assimp=ON` when Qt 6.2 is released.
    # See https://bugreports.qt.io/browse/QTBUG-91537
    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D INSTALL_MKSPECSDIR=share/qt/mkspecs
      -D INSTALL_DESCRIPTIONSDIR=share/qt/modules
    ]

    system "./configure", *config_args, "--", *cmake_args
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
