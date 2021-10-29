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
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{Formula["qt"].opt_include}"

    py = Formula["python@3.9"]
    qt = Formula["qt"]
    xy = Language::Python.major_minor_version py.opt_bin/"python3"
    pyver = xy.to_s.delete "."
    site_packages = prefix/Language::Python.site_packages("python3")
    site_pyside = site_packages/"PySide6"
    pyside_args = %W[
      --no-examples
      --no-qt-tools
      --rpath #{opt_lib}
      --shorter-paths
      --skip-docs
    ]
    system "python3", *Language::Python.setup_install_args(prefix), *pyside_args

    %w[cmake pkgconfig].each { |d| lib.install "pyside3_install/p#{xy}/lib/#{d}" }
    %w[PySide6 shiboken6].each { |l| lib.install Dir[site_packages/l/"lib*"] }
    %w[pyside6 shiboken6].each do |l|
      n = "lib#{l}.cpython-#{pyver}-darwin"
      lib.install_symlink lib/shared_library(n, qt.version.major_minor) => shared_library(n)
      inreplace lib/"pkgconfig/#{l}.pc",
                "#{buildpath}/pyside3_install/p#{xy}".delete_prefix("/private"),
                opt_prefix.to_s
    end
    MachO::Tools.change_rpath "#{site_packages}/shiboken6/Shiboken.cpython-#{pyver}-darwin.so",
      "#{buildpath}/pyside3_build/p#{xy}/shiboken6/libshiboken".delete_prefix("/private"), opt_lib.to_s
    (include/"PySide6").install_symlink Dir[site_pyside/"include/*"]
    (include/"shiboken6").install_symlink Dir[site_packages/"shiboken6_generator/include/*"]
    (share/"PySide6").install_symlink site_pyside/"glue"
    (share/"PySide6").install_symlink site_pyside/"typesystems"

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
    system ENV.cxx, "-std=c++17", "test.cpp",
           "-I#{include}/shiboken6", "-L#{lib}", "-lshiboken6.cpython-#{pyver}-darwin",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
