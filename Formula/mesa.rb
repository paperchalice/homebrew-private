class Mesa < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/5c/46/b4b6eae1e24d9432905ef1d4e7c28b6610e28252527cdc38f2a75997d8b5/PyQt5-5.15.9.tar.gz"
  sha256 "dc41e8401a90dc3e2b692b411bd5492ab559ae27a27424eed4bd3915564ec4c0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e36ecd411d274f6c728ee7be982673d8a843795909a1e6a7294a9c287445292"
    sha256 cellar: :any,                 arm64_monterey: "65d02cc59037ca2eb5dd5ac2d5e19fb46debba9a4b418764592b1cec2fdf0975"
    sha256 cellar: :any,                 arm64_big_sur:  "054b7a3aac3ae4030c2989aca8120e97aa347ac8a8341add5b3358a298fda543"
    sha256 cellar: :any,                 ventura:        "6f3b970bf51f05674d2d7e3a50aee7cd2fe8e68e36d2167781714579d9412d7a"
    sha256 cellar: :any,                 monterey:       "d42f26eec225db2710a8e29939d04ab779b3487c7bc614db576c5d44110419c4"
    sha256 cellar: :any,                 big_sur:        "08f088f6a293b8f0246afe3d25142e0d1faf43012d876bd500b979bdcdd9aca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c706d51bb7d4f4fd8f7839be6a65060267d0939aa8cba042eb4e40f0a8ad49"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.10"  => [:build, :test]
  depends_on "python@3.11"  => [:build, :test]
  depends_on "python@3.9"   => [:build, :test]
  depends_on "sip"          => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  # extra components
  resource "PyQt5-sip" do
    url "https://files.pythonhosted.org/packages/39/5f/fd9384fdcb9cd0388088899c110838007f49f5da1dd1ef6749bfb728a5da/PyQt5_sip-12.11.0.tar.gz"
    sha256 "b4710fd85b57edef716cc55fae45bfd5bfac6fc7ba91036f1dcc3f331ca0eb39"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      site_packages = prefix/Language::Python.site_packages(python)
      args = [
        "--target-dir", site_packages,
        "--scripts-dir", bin,
        "--confirm-license",
        "--no-designer-plugin",
        "--no-qml-plugin"
      ]
      system "sip-install", *args

      resource("PyQt5-sip").stage do
        system python, *Language::Python.setup_install_args(prefix, python)
      end
    end

    # Replace hardcoded reference to Python version used with sip/pyqt-builder with generic python3.
    bin.children.each { |script| inreplace script, Formula["python@3.11"].opt_bin/"python3.11", "python3" }
  end

  test do
    system "echo"
  end
end
