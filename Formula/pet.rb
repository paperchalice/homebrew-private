class Pet < Formula
  desc "Polyhedral Extraction Tool"
  homepage "https://repo.or.cz/pet"
  url "https://repo.or.cz/pet.git",
    tag:      "pet-0.11.5",
    revision: "9246f61776c4ab6585908675547b9b4fb24ca1db"

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
      --with-clang-prefix=#{HOMEBREW_PREFIX}
      --with-isl=system
      --with-libyaml=system
    ]

    system "autoreconf", "-i"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
    (lib/"pkg-config").install "pet.pc"
  end

  test do
    system bin/"pet", "--version"
  end
end
