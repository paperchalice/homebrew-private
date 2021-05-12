class Pyqt < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/64/be/d2b48e53d5767f25d607fa5a598e2af6ef9e1e8475bd6bfc60b27a5f34ea/PyQt6-6.1.0.tar.gz"
  sha256 "9b45df6c404d7297598b91378d1e3f9bdf0970553ebb53c192a9051576098f9b"
  license "GPL-3.0-only"

  depends_on "python@3.9"
  depends_on "qt"

  # build env
  resource "sip" do
    url "https://files.pythonhosted.org/packages/44/76/d9722bb934c7ca31f4bcf471d5f781b7ffed3a60f10c858a676d3a9aa1a0/sip-6.1.0.tar.gz"
    sha256 "f069d550dd819609e019e5dc58fc5193e081c7f3fb4f7dc8f9be734e34d4e56e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "pyqt-builder" do
    url "https://files.pythonhosted.org/packages/12/29/af52add4755b7dbce928fe3df1b86a48d5c8bcd06e3333bf8f69ad19c1a5/PyQt-builder-1.10.0.tar.gz"
    sha256 "86bd19fde83d92beaefacdeac1e26c6e1918c300ff78d7ec2a19973bf2cf21b5"
  end

  # others
  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/50/24/743c4dd6a93d25570186a7940c4f072db1cf3fa919169b0ba598fcfc820a/PyQt6_sip-13.1.0.tar.gz"
    sha256 "7c31073fe8e6cb8a42e85d60d3a096700a9047c772b354d6227dfe965566ec8a"
  end

  resource "3d" do
    url "https://files.pythonhosted.org/packages/f7/06/6a2d193f36d2f115fcfaac6375f05737270bc8c133cd259a7a3431c38152/PyQt6_3D-6.1.0.tar.gz"
    sha256 "8f04ffa5d8ba983434b0b12a63d06e8efab671a0b2002cee761bbd0ef443513c"
  end

  resource "charts" do
    url "https://files.pythonhosted.org/packages/bd/d3/3c5ddec0e55f0776aa4d975574805c8035fa180458c902d0d1912c9f4094/PyQt6_Charts-6.1.0.tar.gz"
    sha256 "46c83c1bf044c3d86cdc38c2eb37168432e0cc877e54fc3522af11f00021a7f4"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/90/38/32971bd2b41a29f80aff5571ea68bb4a42c6b3fd58110f116ec05eb596a9/PyQt6_DataVisualization-6.1.0.tar.gz"
    sha256 "8d259abe586efcc970b606c167900e98847ed47b5b63fa0673758f7c9829cf2f"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/92/3d/3088bcf0bcba3b586c401dad60f7706224966e8861653088e5786115f66c/PyQt6_NetworkAuth-6.1.0.tar.gz"
    sha256 "11af1bb27a6b3686db8770cd9c089be408d4db93115ca77600e6c6415e3d318c"
  end

  def install
    python = Formula["python@3.9"]

    build_venv = virtualenv_create(buildpath/"build_venv", "python3")
    %w[sip packaging pyparsing toml pyqt-builder].each { |p| build_venv.pip_install p }
    ENV.append_path "PATH", buildpath/"build_venv/bin"

    site_packages = prefix/Language::Python.site_packages("python3")
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system python.bin/"python3", *Language::Python.setup_install_args(prefix)
    end

    %w[3d charts datavis networkauth].each do |p|
      resource(p).stage do
        open("pyproject.toml", "a") do |f|
          f.puts "[tool.sip.project]"
          f.puts "sip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]"
        end
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}"
    # TODO: add additional libraries in future: Position, Multimedia
    %w[
      Gui
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
