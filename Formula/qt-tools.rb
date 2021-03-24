class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/submodules/qttools-everywhere-src-6.0.2.tar.xz"
  sha256 "465c3edf370db4df8e41a72ae35a6bcb2d7677210669f1934089de565af4f8e9"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-tools-6.0.2_1"
    sha256 cellar: :any, big_sur: "3383e497ba1377e41e44e97abe7a349aa5cadcee5973aa6c2668e14688cb8813"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :build
  depends_on "ninja" => :build

  depends_on "qt-base"

  def install
    inreplace "cmake/FindWrapLibClang.cmake", "${__qt_clang_genex_condition}", "0"

    args =std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_EXE_LINKER_FLAGS=-L/usr/lib
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]

    system "cmake", "-G", "Ninja", ".", *args
    system "cmake", "--build", ".", "--parallel"
    system "cmake", "--install", "."

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

    llvm = Formula["llvm"]
    llvm_prefix = llvm.prefix llvm.version
    llvm_prefix += "_#{llvm.revision}" if llvm.revision.positive?
    %w[qdoc lupdate].each do |file|
      MachO::Tools.change_install_name(bin/file, "#{llvm_prefix}/lib/libclang.dylib",
      "#{MacOS::CLT::PKG_PATH}/usr/lib/libclang.dylib")
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
