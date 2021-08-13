class BoostUtility < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/utility/"
  url "https://github.com/boostorg/utility.git",
    tag:      "boost-1.77.0",
    revision: "375382e1e6c677c7849e894675251db353ab9186"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-utility-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "786e0d4c7c504f47a88c9f7604bc6f4f7cb563f9273b6d55c4a3812f0596ea8c"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
