class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2024b.tar.lz"
  sha256 "22674a67786d3ec1b0547305904011cb2b9126166e72abbbea39425de5595233"
  license all_of: ["BSD-3-Clause", :public_domain]

  depends_on "gettext"

  def install
    gettext = Formula["gettext"]
    make_args = %W[
      CFLAGS=-Oz\ -DHAVE_GETTEXT\ -I#{gettext.include}\ -L#{gettext.lib}
      LDLIBS=-lintl
      USRDIR=#{prefix}
      TZDEFAULT=#{prefix}/etc/localtime
    ]
    system "make", *make_args, "install"
  end

  test do
    assert_match "UTC", shell_output("#{bin}/zdump UTC")
  end
end
