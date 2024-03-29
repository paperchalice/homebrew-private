class Pet < Formula
  desc "Polyhedral Extraction Tool"
  homepage "https://repo.or.cz/pet"
  url "https://repo.or.cz/pet.git",
    tag:      "pet-0.11.5",
    revision: "9246f61776c4ab6585908675547b9b4fb24ca1db"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/pet-0.11.5"
    rebuild 1
    sha256 cellar: :any, monterey: "f70618aac547dfed2a163ed1554acde3f1d10531db1b5e04787f181b7ddfd6db"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf"  => :build

  depends_on "clang"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libyaml"
  depends_on "llvm-core"

  def install
    configure_args = std_configure_args + %W[
      --disable-static
      --with-clang-prefix=#{HOMEBREW_PREFIX}
      --with-isl=system
      --with-libyaml=system
    ]

    system "autoreconf", "-i"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
    (lib/"pkgconfig").install "pet.pc"
  end

  test do
    system bin/"pet", "--version"
  end
end
