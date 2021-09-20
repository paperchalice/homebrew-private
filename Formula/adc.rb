class Adc < Formula
  desc "Test ada"
  homepage "https://www.adacore.com/"
  url "https://zlib.net/zlib-1.2.11.tar.gz"
  sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  depends_on "tree" => :build

  resource "bootstrap_gcc" do
    url "https://community.download.adacore.com/v1/aefa0616b9476874823a7974d3dd969ac13dfe3a?filename=gnat-2020-20200818-x86_64-darwin-bin.dmg"
    sha256 "915cd7260ef1bc363d4ff6249343183c4f989ec0a7d779f125a5be6c194f790f"
  end

  resource "script" do
    url "https://raw.githubusercontent.com/AdaCore/gnat_community_install_script/master/install_script.qs"
    sha256 "93df6ca93265e97add6751e34a88e11dbcf8eb64657b49c12b4bb3d53f1a5acd"
  end

  def install
    resource("bootstrap_gcc").stage(buildpath/"bootstrap_gcc")
    resource("script").stage(buildpath)

    gcc_installer = (buildpath/"bootstrap_gcc/Contents/MacOS").glob("*")[0]
    rm_rf "bootstrap_gcc/Contents/Info.plist"
    system "ls", "./bootstrap_gcc/Contents/MacOS"
    args = %W[
      --script=#{buildpath}/install_script.qs
      InstallPrefix=#{buildpath}/bgc
      --verbose
    ]
    system gcc_installer.to_s, *args
    system "tree", "./bgc"
    system "false"
  end

  test do
    system "echo"
  end
end
