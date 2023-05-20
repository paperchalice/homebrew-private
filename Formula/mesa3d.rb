class Mesa3d < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-23.1.2.tar.xz"
  sha256 "60b1f3adb1561830c158bf3c68508943674fb9d69f384c3c7289694385ab5c7e"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  depends_on "bindgen" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "libclc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygments" => :build
  depends_on "python" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  depends_on "spirv-llvm-translator" => :build
  depends_on "xorgproto" => :build

  depends_on "clang"
  depends_on "expat"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"
  depends_on "llvm-core"
  depends_on "spirv-tools"

  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "glslang"
    depends_on "gzip"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  def install
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, "python3")

    %w[Mako MarkupSafe].each do |res|
      venv.pip_install resource(res)
    end

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    args = %w[
      -Db_ndebug=true
      -Drust_std=2021
      -Dllvm=enabled
      -Dgallium-rusticl=true
      -Dgallium-opencl=icd
      -Dgles1=enabled
      -Dgles2=enabled
    ]

    if OS.linux?
      args += %w[
        -Dplatforms=x11,wayland
        -Dglx=auto
        -Ddri3=enabled
        -Dgallium-drivers=auto
        -Dgallium-omx=disabled
        -Degl=enabled
        -Dgbm=enabled
        -Dopengl=true
        -Dvalgrind=disabled
        -Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,lima
      ]
    end

    if OS.mac?
      args += %W[
        -Dc_std=c2x
        -Dplatforms=auto
        -Dglx=xlib
        -Dosmesa=true
        -Dmoltenvk-dir=#{Formula["molten-vk"].prefix}
        -Dgallium-drivers=swrast,zink
        -Dtools=etnaviv,glsl,nir,nouveau,lima
      ]
      inreplace "src/compiler/spirv/nir_load_libclc.c", "st_mtim", "st_mtimespec"
    end

    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"

    if OS.linux?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
    system "echo"
  end
end
