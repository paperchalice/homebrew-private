class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.3/single/qt-everywhere-src-6.0.3.tar.xz"
  sha256 "ca4a97439443dd0b476a47b284ba772c3b1b041a9eef733e26a789490993a0e3"
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

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt-tools" => :build

  resource "qtimageformats" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtimageformats-everywhere-src-6.0.3.tar.xz"
    sha256 "327580b5a5b9a8d75e869c0eaa7ff34881bbde4e4ccc51d07a59e96054136837"
  end

  resource "qt3d" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qt3d-everywhere-src-6.0.3.tar.xz"
    sha256 "470f95c559b68cc8faa982c1ca7ff83054d6802f7b2a0c1d960a155b92080cf9"
  end

  resource "qtnetworkauth" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtnetworkauth-everywhere-src-6.0.3.tar.xz"
    sha256 "124bf433e2c5418e900a5947d4ceb128ee179f514eddcea33924f0b695be64ed"
  end

  def install
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
    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"]||s["CMAKE_FIND_FRAMEWORK"] } + %W[
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -D CMAKE_FIND_FRAMEWORK=FIRST

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
