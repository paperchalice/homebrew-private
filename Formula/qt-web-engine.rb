class QtWebEngine < Formula
  include Language::Python::Virtualenv

  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtwebengine-everywhere-src-6.3.0.tar.xz"
  sha256 "2001b45dd81dcb7ad1bc6cf1aa32f2eca5367a11fed49656053c75676c4d093d"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-web-engine-6.2.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "99c778ca08bec64fdb86fe282aaec81f75824cf092851731b6f3daa295a3ea60"
  end

  depends_on "ccache"  => :build
  depends_on "cmake"   => [:build, :test]
  depends_on "ninja"   => :build
  depends_on "node"    => :build
  depends_on "perl"    => :build
  depends_on "pkgconf" => :build
  depends_on "python"  => :build
  # TODO: depends_on "qt"      => :build

  depends_on "minizip"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-positioning"
  depends_on "qt-tools"
  depends_on "qt-web-channel"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  patch do
    url "https://github.com/qt/qtwebengine/commit/8fd6601ef64dc22e48ec9c14440262f88d82cd4e.patch?full_index=1"
    sha256 "e5edbe5cdafa105b9fe37b667fa6a43864d0f7de7b8d265411d083229fb8bcac"
  end

  def copy_brew
    qt = Formula["qt"]

    mkdir_p lib/"cmake/Qt#{version.major}"
    mkdir_p lib/"metatypes"
    mkdir_p share/"qt/modules"
    mkdir_p share/"qt/qml"
    mkdir_p share/"qt/mkspecs/modules"

    (lib/"cmake/Qt#{version.major}").install Dir["cmake/Find*"]
    cp_r qt.lib.glob("QtWebEngine*"), lib
    cp_r (qt.lib/"cmake").glob("qt#{version.major}webengine*"), lib/"metatypes"
    cp_r (qt.lib/"metatypes").glob("Qt#{version.major}WebEngine*"), lib/"cmake"
    cp_r (qt.pkgshare/"modules").glob("WebEngine*"), share/"qt/modules"
    cp_r (qt.pkgshare/"mkspecs/modules").glob("qt_lib_webengine*"), share/"qt/mkspecs/modules"
    cp_r (qt.pkgshare/"qml").glob("QtWebEngine*"), share/"qt/qml"
  end

  def real_install
    python = Formula["python"]
    venv = virtualenv_create(buildpath/"venv", python.bin/"python3")
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/(Language::Python.site_packages "python3")
    ENV.prepend_path "PATH", Formula["python"].libexec/"bin"

    inreplace "src/3rdparty/chromium/build/toolchain/apple/toolchain.gni",
        'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'
    inreplace "src/3rdparty/gn/src/base/files/file_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"
    %w[
      cmake/Gn.cmake
      src/gn/CMakeLists.txt
    ].each { |s| inreplace s, "REALPATH", "ABSOLUTE" }

    cd "src/3rdparty/chromium/third_party/zlib" do
      mkdir_p "minizip/contrib"
      cp Dir[Formula["minizip"].include/"minizip/*"], "minizip/contrib"
      cp "contrib/minizip/iowin32.h", "minizip/contrib"
    end
    cd "src/3rdparty/chromium/build/linux/unbundle" do
      system_libs = %w[
        zlib
        libxml
        libxslt
      ]
      system "./replace_gn_files.py", "--system-libraries", *system_libs
    end

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
      -G Ninja
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  def install
    # copy_brew
    real_install
  end

  test do
    system "echo"
  end
end
