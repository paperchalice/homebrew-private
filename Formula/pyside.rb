class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.2.0-src/pyside-setup-opensource-src-6.2.0.tar.xz"
  sha256 "fed210b662129955332d2609a900b5b8643130134e4682371b26a9ba60740d01"
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
  depends_on "llvm@12"
  depends_on "python@3.9"
  depends_on "qt"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import shiboken6"

    # TODO: add modules `Position`, `Multimedia`and `WebEngineWidgets` when qt6.2 is released
    # arm support will finish in qt6.1
    modules = %w[
      Core
      Gui
      Network
      Quick
      Svg
      Widgets
      Xml
    ]

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6.Qt#{mod}" }

    pyincludes = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --includes").chomp.split
    pylib = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(Formula["python@3.9"].opt_bin/"python3").to_s.delete(".")

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken6"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken6", "-L#{lib}", "-lshiboken6.cpython-#{pyver}-darwin",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
