class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.3/submodules/qttools-everywhere-src-6.0.3.tar.xz"
  sha256 "632f12f767b4cdd6943c04b37cc718044bc5a5f811aabd7198fd66ff6c072b27"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-tools-6.0.3_1"
    sha256 cellar: :any, big_sur: "e8a5a659e69084ed48b472724b2ba44f66e33d3b00eb675feaa60c568764bdd0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "clang"
  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    inreplace "cmake/FindWrapLibClang.cmake", "INTERFACE libclang",
      'INTERFACE libclang "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>"'

    args =std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_EXE_LINKER_FLAGS=-L/usr/lib
      -DCMAKE_SHARED_LINKER_FLAGS=-L/usr/lib
      -DCMAKE_MODULE_LINKER_FLAGS=-L/usr/lib
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]

    system "cmake", "-G", "Ninja", ".", *args
    system "cmake", "--build", "."
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
