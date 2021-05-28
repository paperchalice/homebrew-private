class Sudo < Formula
  desc "Su and do"
  homepage "https://www.sudo.ws/"
  url "https://www.sudo.ws/dist/sudo-1.9.7.tar.gz"
  sha256 "2bbe7c2d6699b84d950ef9a43f09d4d967b8bc244b73bc095c4202068ddbe549"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/sudo-1.9.7"
    sha256 big_sur: "39b6ce47966f4d1697d372794c69d0b040429676337b6c299dde868826bcf9aa"
  end

  depends_on "python" => :build

  depends_on "gettext"

  uses_from_macos "krb5"
  uses_from_macos "openldap"

  def install
    args = std_configure_args + %W[
      --sysconfdir=#{etc}
      --with-all-insults
      --with-env-editor
      --with-ldap
    ]
    system "./configure", *args
    system "make"
    system "make", "install", "-i"
  end

  test do
    system "echo"
  end
end
