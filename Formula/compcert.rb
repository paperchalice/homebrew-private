class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "https://compcert.org/"
  url "https://github.com/AbsInt/CompCert/archive/refs/tags/v3.9.tar.gz"
  sha256 "6a56b4e4c2b6e776eba43a1a08047c9efd6874244bd2d8c48ccb6ccd1117aefb"
  license "LGPL-2.1-only"

  depends_on "coq"    => :build
  depends_on "menhir" => :build
  depends_on "ocaml"  => :build

  def install
    # We pass -ignore-coq-version, otherwise every new version of coq
    # breaks the strict version check.
    configure_args = %W[
      -prefix #{prefix}
      #{Hardware::CPU.arch}-macosx
      -ignore-coq-version
      -clightgen
    ]
    system "./configure", *configure_args
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
