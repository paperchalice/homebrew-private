class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.2.2-src/pyside-setup-opensource-src-6.2.2.tar.xz"
  sha256 "70a74c7c7c9e5af46cae5b1943bc39a1399c4332b342d2c48103a1cfe99891a8"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  def install
    python = Formula["python@3.9"]
    venv = virtualenv_create(buildpath/"venv", python.opt_bin/"python3")
    venv.pip_install resources

    pyside_args = %w[
      --no-examples
      --no-qt-tools
      --rpath @loader_path/../shiboken6
      --shorter-paths
      --skip-docs
    ]
    system buildpath/"venv/bin/python3", *Language::Python.setup_install_args(prefix), *pyside_args
  end

  test do
    system "echo"
  end
end
