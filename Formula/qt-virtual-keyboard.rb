class QtVirtualKeyboard < Formula
  desc "Qt Quick virtual keyboard"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/additional_libraries/6.1/6.1.0/qtvirtualkeyboard-everywhere-src-6.1.0.tar.xz"
  sha256 "511bdfbf6f573b0460424bf582fe935382e870812f8b47aebf2b80fd54e48b85"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-svg"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] || s["CMAKE_BUILD_TYPE"] } + %W[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir[lib/"*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end
  end

  test do
    system "echo"
  end
end
