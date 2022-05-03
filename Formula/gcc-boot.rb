class GccBoot < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.3.0/gcc-11.3.0.tar.xz"
  sha256 "b47cf2818691f5b1e21df2bb38c795fac2cfbd640ede2d0a5e1c89e338a3ac39"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  keg_only "bootstrap formula"

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  resource "bootstrap_gcc" do
    url "https://downloads.sourceforge.net/project/gnuada/GNAT_GCC%20Mac%20OS%20X/11.2.0/native/gcc-11.2.0-x86_64-apple-darwin15.pkg"
    sha256 "d1ed487ec5f8243ba9c8781cd3039a29091817a211f277003d3b6ea4217b5e1b"
  end

  def install
    resource("bootstrap_gcc").stage do
      system "pkgutil", "--expand-full", "gcc-11.2.0-x86_64-apple-darwin15.pkg", buildpath/"bootstrap_gcc"
    end
    bootstrap_gcc_prefix = buildpath/"bootstrap_gcc/gcc-11.2.0-x86_64-apple-darwin15.pkg/Payload"
    inreplace "configure", /\${CC}(?= -c conftest\.adb)/, bootstrap_gcc_prefix/"bin/gcc"
    open("gcc/ada/gcc-interface/Make-lang.in", "a") { |f| f.puts "override CC = #{bootstrap_gcc_prefix}/bin/gcc" }
    ENV.prepend_path "PATH", bootstrap_gcc_prefix/"bin"
    ENV["ADAC"] = bootstrap_gcc_prefix/"bin/gcc"

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
  end

  test do
    system "echo"
  end
end
