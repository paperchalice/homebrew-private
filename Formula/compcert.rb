class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "https://compcert.org/"
  url "https://github.com/AbsInt/CompCert/archive/refs/tags/v3.15.tar.gz"
  sha256 "6baae8f69bdbf0192d02fae911207cbde73bb1ff6b9790b1e745be0bd9b2342a"
  license :cannot_represent

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/compcert-3.15"
    sha256 cellar: :any_skip_relocation, ventura: "17247517400a69e204a20a408a6506010576bcee86e300cd98422353b0f70005"
  end

  depends_on "coq"    => :build
  # TODO: depends_on "menhir" => :build
  depends_on "ocaml"  => :build
  depends_on "opam" => :build

  def install
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "install", "menhir"
    ENV.append_path "PATH", opamroot/"default/bin"

    # We pass -ignore-coq-version, otherwise every new version of coq
    # breaks the strict version check.
    configure_args = %W[
      -prefix #{prefix}
      #{Hardware::CPU.arch}-macosx
      -ignore-coq-version
      -ignore-ocaml-version
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
