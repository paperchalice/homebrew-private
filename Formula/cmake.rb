class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz"
  sha256 "aecf6ecb975179eb3bb6a4a50cae192d41e92b9372b02300f9e8f1d5f559544e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --qt-gui
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"

    libexec.install bin/"CMake.app"
    bin.write_exec_script libexec/"CMake.app/Contents/MacOS/CMake" => "cmake-gui"
    system "macdeployqt", libexec/"CMake.app"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
