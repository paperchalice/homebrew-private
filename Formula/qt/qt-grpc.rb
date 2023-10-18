class QtGrpc < Formula
  desc "Qt RPC with protobuf and gRPC"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtgrpc-everywhere-src-6.5.0.tar.xz"
  sha256 "589f4b368c6b5df3f9049ece9f9e99a67a700f5d78a8c21a7ae3798a4ace2ff3"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-grpc-6.5.0"
    sha256 cellar: :any, monterey: "d4ee22c62cda642617cfcb97a404bd05b26518e1d5358a835ecd0ca7066ac9b6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "grpc"
  depends_on "protobuf"
  depends_on "qt-base"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}
      -D FEATURE_native_grpc=ON

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  test do
    system "echo"
  end
end
