class Sudo < Formula
  desc "Su and do"
  homepage "https://www.sudo.ws/"
  url "https://www.sudo.ws/dist/sudo-1.9.7.tar.gz"
  sha256 "2bbe7c2d6699b84d950ef9a43f09d4d967b8bc244b73bc095c4202068ddbe549"

  depends_on "python" => :build

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
