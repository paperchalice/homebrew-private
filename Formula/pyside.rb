class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.2.1-src/pyside-setup-opensource-src-6.2.1.tar.xz"
  sha256 "e0df6f42ed92e039d44ae9bf7d23cc4ee2fc4722c87adddbeafc6376074c4cd4"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 arm64_big_sur: "efae3429af6fe9874fdfb68c0a03eccdb4cd51d99e1988359893f988da942e3d"
    sha256 big_sur:       "8997fc533892a03fa5f8eac3537a27411d882ff9090a4185b49266009f8e350b"
    sha256 catalina:      "219c2f14334177d0e658209de9bb450b5ed3d2a3ee5ee55e51d6b2a6500ec11a"
    sha256 mojave:        "66832f9ecd35b3713032d1f9488b2059cab34d99a9be3ce5bfcef3685283275c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{Formula["qt"].opt_include}"

    qt = Formula["qt"]
    site_packages = prefix/Language::Python.site_packages("python3")
    site_pyside = site_packages/"PySide6"
    pyside_args = %w[
      --no-examples
      --no-qt-tools
      --shorter-paths
      --rpath=@loader_path/../shiboken6
      --skip-docs
    ]
    system "python3", *Language::Python.setup_install_args(prefix), *pyside_args

    # install tools symlinks
    %w[lupdate lrelease].each { |x| site_pyside.install_symlink qt.opt_bin/x }
    %w[uic rcc].each { |x| (site_pyside/"Qt/libexec").install_symlink qt.opt_pkgshare/"libexec"/x }
    %w[assistant linguist].each { |x| site_pyside.install_symlink qt.opt_bin/x.capitalize => x }
    site_pyside.install_symlink qt.opt_libexec/"Designer.app"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import shiboken6"

    modules = %w[
      Core
      Gui
      Network
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    modules << "WebEngineCore" if OS.mac? && (DevelopmentTools.clang_build_version > 1200)

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6.Qt#{mod}" }
  end
end
