class GccStrap < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.3.0/gcc-11.3.0.tar.xz"
  sha256 "b47cf2818691f5b1e21df2bb38c795fac2cfbd640ede2d0a5e1c89e338a3ac39"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-strap-11.3.0"
    sha256 monterey: "7a40a9a4ee92e7766cd57ebdc8a32264ec17f96542f3c79a43d4dead27181c41"
  end

  keg_only "bootstrap formula"

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc-boot" => :build

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def install
    ENV.prepend_path "PATH", Formula["gcc-boot"].bin
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"

    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"
    languages = %w[ada c c++ d objc obj-c++ fortran]

    configure_args = %W[
      --build=#{triple}
      --prefix=#{prefix}
      --disable-multilib
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join(",")}
      --with-gcc-major-version-only
      --with-sysroot=#{MacOS.sdk_path}
    ]

    system "./contrib/download_prerequisites"
    mkdir "build" do
      system "../configure", *configure_args
      system "make"
      system "make", "install"
    end
    MachO::Tools.add_rpath "#{lib}/gcc/#{triple}/#{version.major}/adalib/#{shared_library "libgnarl"}",
                           "@loader_path"
  end

  test do
    system "echo"
  end
end
