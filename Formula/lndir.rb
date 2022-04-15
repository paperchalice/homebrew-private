class Lndir < Formula
  desc "Create a shadow directory of symbolic links to another directory tree"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/util/lndir-1.0.3.tar.bz2"
  sha256 "49f4fab0de8d418db4ce80dad34e9b879a4199f3e554253a8e1ab68f7c7cb65d"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lndir-1.0.3"
    sha256 cellar: :any_skip_relocation, monterey: "bb4fe959d88c22240278b94d9765bc3c90cab8aa9bd96c9dbe40faef8409a95c"
  end

  depends_on "pkgconf"   => :build
  depends_on "xorgproto" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"lndir", bin, "test"
    assert_match bin.to_s, shell_output("ls -l ./test")
  end
end
