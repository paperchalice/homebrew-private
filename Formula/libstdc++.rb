class Libstdcxx < Formula
  desc "GNU C++ Library"
  homepage "https://gcc.gnu.org/onlinedocs/libstdc++/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  depends_on "python" => :build

  uses_from_macos "libiconv"

  def install
    cd "libstdc++-v3"
    ENV.append_to_cflags "-nostdlibinc -I#{MacOS.sdk}/usr/include"
    configure_args = std_configure_args + %W[
      --disable-multilib
      --with-gcc-major-version-only
      --with-python-dir=#{Language::Python.site_packages "python3"}
    ]
    mkdir "build" do
      system "../configure", *configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "echo"
  end
end
