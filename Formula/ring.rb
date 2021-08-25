class Ring < Formula
  desc "Simple and flexible programming language for applications development"
  homepage "http://ring-lang.net/"
  url "https://github.com/ring-lang/ring.git",
    tag:      "v1.14",
    revision: "defdc0b24bfb569f4b7de541eee70112b8e2eef8"
  license "MIT"

  depends_on "allegro"
  depends_on "glew"
  depends_on "httpd"
  depends_on "libpq"
  depends_on "libuv"
  depends_on "mysql-client"
  depends_on "openssl"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"
  depends_on "sdl2_ttf"
  depends_on "unixodbc"

  def install
    # Build Ring (Compiler/VM)
    cd "language/src" do
      inreplace "buildclang.sh", "sudo ./install.sh", ""
      system "./buildclang.sh"
    end

    # Build Ring2EXE
    cd "tools/ring2exe" do
      system bin/"ring", "ring2exe.ring", "ring2exe.ring"
      libexec.install "ring2exe"
      bin.write_exec_script libexec/"ring2exe"
    end

    # Generate RingConsoleColors Source Code and Build
    cd "extensions/ringconsolecolors" do
      system "./buildclang.sh"
    end
  end

  test do
    system "echo"
  end
end
