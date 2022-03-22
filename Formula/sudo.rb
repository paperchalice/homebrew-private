class Sudo < Formula
  desc "Su and do"
  homepage "https://www.sudo.ws/"
  url "https://www.sudo.ws/dist/sudo-1.9.8p2.tar.gz"
  version "1.9.8p2"
  sha256 "9e3b8b8da7def43b6e60c257abe80467205670fd0f7c081de1423c414b680f2d"

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
