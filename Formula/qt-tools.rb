class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.1/submodules/qttools-everywhere-src-6.2.1.tar.xz"
  sha256 "5a856d3d3d5fe6e15dc3f1af707a0ef1df2e687850403fc94af635edb9312bfb"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-tools-6.2.0"
    sha256 cellar: :any, big_sur: "959d6a3dd510fc235a1e9a0b9552337b0dc939123ce25e0fb7078ec79daccb37"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "clang"
  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["libc++"].lib
    ENV.prepend "PATH", "/usr/bin"
    inreplace "cmake/FindWrapLibClang.cmake", "INTERFACE libclang",
      'INTERFACE libclang "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>"'

    args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    rm bin/"qtdiag"
    bin.install_symlink bin/"qtdiag#{version.major}" => "qtdiag"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  test do
    # test `qtdoc`
    (testpath/"test.qdocconf").write <<~EOS
      project = test
      outputdir   = html
      headerdirs  = .
      sourcedirs  = .
      exampledirs = .
      imagedirs   = .
    EOS
    system bin/"qdoc", testpath/"test.qdocconf"
    assert_predicate testpath/"html/test.index", :exist?
  end
end
