class GccBoot < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-boot-12.2.0"
    rebuild 1
    sha256 monterey: "b2ac6bfc13894e47b52f50b63cf5277a5830e88cc147a1ea76f529e2837b5a7a"
  end

  keg_only "bootstrap formula"

  depends_on "gcc-strap" => :build

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def install
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"

    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"
    languages = %w[ada c c++ d objc obj-c++ fortran]
    sr = MacOS.sdk_path.to_str.tr "0-9", ""

    configure_args = %W[
      --build=#{triple}
      --prefix=#{prefix}
      --disable-multilib
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join(",")}
      --with-gcc-major-version-only
      --with-sysroot=#{sr}
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
