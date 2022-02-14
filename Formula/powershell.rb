class Powershell < Formula
  desc "Modern command shell"
  homepage "https://microsoft.com/PowerShell"
  url "https://github.com/PowerShell/PowerShell/archive/refs/tags/v7.2.1.tar.gz"
  sha256 "50b7083f0ece54a46ecd077b5a627448b67b2bd10220ff17dc585630a7bcb4ab"

  depends_on "dotnet"
  depends_on "openssl@3"

  resource "bootstrap-pwsh" do
    url "https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/powershell-7.2.1-osx-x64.tar.gz"
    sha256 "331307ecf7cc28e7ecc7afa7d0ba4527677996fddfc0c08b913bb4b8adcd8c3d"
  end

  def install
    resource("bootstrap-pwsh").stage buildpath/"bootstrap-pwsh"
    chmod "+x", buildpath/"bootstrap-pwsh/pwsh"
    inreplace "./build.psm1", "[bool](Get-Command brew -ErrorAction ignore)", "$true"
    system buildpath/"bootstrap-pwsh/pwsh", "-c",
      "Import-Module ./build.psm1;Start-PSBuild -Configuration 'Release'"
    system "ls", "./src/powershell-unix/bin/Release"
  end

  test do
    system "echo"
  end
end
