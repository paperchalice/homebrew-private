class BoostTypeTraits < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/type_traits/"
  url "https://github.com/boostorg/type_traits.git",
    tag:      "boost-1.77.0",
    revision: "bfce306637e2a58af4b7bbc881a919dafb7d195b"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-type-traits-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1e7f7c1326c586fc970ae4efd7712a711d361485c6476eda81fdc6ea0a1e2b80"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
