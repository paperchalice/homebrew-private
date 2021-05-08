class QtCharts < Formula
  desc "State Machine Notation compiler and related tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.0/submodules/qtcharts-everywhere-src-6.1.0.tar.xz"
  sha256 "8f70dc54b3f29eed91cf207db4185cef25f3d0bbc479059725c75c1895cddfcd"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtcharts.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-charts-6.1.0"
    sha256 cellar: :any, big_sur: "d56aee2ea0abb348c43c6c4f6644f1248952e15be9943c208ee07a3cd67e7090"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
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
