class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.3/submodules/qttools-everywhere-src-6.1.3.tar.xz"
  sha256 "29c1e305752791070f5dee2182ba9a44a489a1217911ceafca063f1007e6fb38"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-tools-6.1.3"
    sha256 cellar: :any, big_sur: "744099ddfacb3769dcd0a175879792b717e3e9dad2b6ffc5bd7014a9be6f4a6f"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf" => :build

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
