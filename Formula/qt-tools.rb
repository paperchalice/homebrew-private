class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.0/submodules/qttools-everywhere-src-6.1.0.tar.xz"
  sha256 "6263030c1120a30b0541d37b52dc0be0ea04bbb8d1695ec9648f0bd77e421f3e"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-tools-6.1.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "beec9aad3b8c322d7ac7adfcaa79ea9dacd74c35aad8f62f73b111ae4bbd75fc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "clang"
  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["libc++"].lib
    inreplace "cmake/FindWrapLibClang.cmake", "INTERFACE libclang",
      'INTERFACE libclang "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>"'

    args =std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    libexec.mkpath
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec
      bin.write_exec_script "#{libexec/app.stem}.app/Contents/MacOS/#{app.stem}"
    end
  end

  test do
    # test `qtpaths`
    assert_equal HOMEBREW_PREFIX.to_s, `qtpaths --install-prefix`.strip

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
