class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qttools-everywhere-src-6.1.2.tar.xz"
  sha256 "a0520097ac1f898381c4512fb55ba5aa187d8e4e06ed0dcd2cbe265cd037989b"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-tools-6.1.2"
    sha256 cellar: :any, big_sur: "415c19ef6ccc342f07ba4bcea3e40399ec15210e1e1f9b8e90567c52f4118c51"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "clang"
  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["libc++"].lib
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

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    Pathname.glob(bin/"*.app") do |app|
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
