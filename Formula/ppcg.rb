class Ppcg < Formula
  desc "Polyhedral Extraction Tool"
  homepage "https://repo.or.cz/ppcg"
  url "https://repo.or.cz/ppcg.git",
    tag:      "ppcg-0.08.5",
    revision: "d9a30c04d3b6d832d30545abaf907ea257b59d8a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf"  => :build

  depends_on "isl"
  depends_on "pet"

  def install
    configure_args = std_configure_args + %W[
      --disable-static
      --with-isl=system
      --with-pet=system
      --with-isl-prefix=#{Formula["isl"].prefix}
      --with-pet-prefix=#{Formula["pet"].prefix}
    ]

    system "autoreconf", "-i"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
