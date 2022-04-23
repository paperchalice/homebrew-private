class Tradcpp < Formula
  desc "K&R-style C preprocessor"
  homepage "https://www.netbsd.org/~dholland/tradcpp"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.5.3.tar.gz"
  sha256 "e17b9f42cf74b360d5691bc59fb53f37e41581c45b75fcd64bb965e5e2fe4c5e"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/tradcpp-0.5.3"
    sha256 cellar: :any_skip_relocation, monterey: "0f36a7c793079b155824dde2acfb5545598b1ee57c23244860a6e9076bd40e17"
  end

  depends_on "bmake" => :build

  def install
    system "bmake"
    system "bmake", "prefix=#{prefix}", "MK_INSTALL_AS_USER=yes", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define FOO bar
      FOO
    EOS
    assert_match "bar", shell_output("#{bin}/tradcpp ./test.c")
  end
end
