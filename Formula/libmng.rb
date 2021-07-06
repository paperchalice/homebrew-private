class Libmng < Formula
  desc "Create and manipulate MNG format graphics files"
  homepage "https://libmng.com/"
  url "https://downloads.sourceforge.net/sourceforge/libmng/libmng-2.0.3.tar.xz"
  sha256 "4a462fdd48d4bc82c1d7a21106c8a18b62f8cc0042454323058e6da0dbb57dd3"
  license any_of: ["Zlib", "Libpng"]

  depends_on "pkg-config" => :build

  depends_on "jpeg"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libmng.h>

      int main()
      {
        mng_version_text();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmng", "-o", "test"
    system "./test"
  end
end
