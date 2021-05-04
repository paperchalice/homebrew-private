class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.4/single/qt-everywhere-src-6.0.4.tar.xz"
  sha256 "677db6472420f9046b16f7c0d0aa15c4f11f344462a6374feb860625c12fc72b"
  license "GFDL-1.3-only"
  head "https://code.qt.io/qt/qtdoc.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-doc-6.0.3"
    sha256 cellar: :any_skip_relocation, big_sur: "70e83bc35efa2db032e4d6fd81d65611771d8e255d14bf70388264ab07914519"
  end

  depends_on "cmake"      => :build
  depends_on "llvm"       => :build
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build
  depends_on "python"     => :build

  resource "qt3d" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.4/qt3d-everywhere-src-6.0.4.tar.xz"
    sha256 "d6970593f4ab2d94c7beedf217ce4456c69f647251aa661a7de3a6ccf1b618ff"
  end

  resource "qtimageformats" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.4/qtimageformats-everywhere-src-6.0.4.tar.xz"
    sha256 "c284b2eb413a7cf62ba7168c693b7498539fc41dfd9f29dd3ce5c5b46d8d1073"
  end

  resource "qtnetworkauth" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.4/qtnetworkauth-everywhere-src-6.0.4.tar.xz"
    sha256 "108c761dde84c346a292e875a24bfba7a0e1d0ea3e0238149fe9ac11a3de92e9"
  end

  def install
    inreplace "qtbase/cmake/FindGSSAPI.cmake", "gssapi_krb5", ""
    resources.each { |addition| addition.stage buildpath/addition.name }

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

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
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}

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
