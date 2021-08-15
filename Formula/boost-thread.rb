class BoostThread < Formula
  desc "Multiple threads of execution with shared data in portable C++ code"
  homepage "https://boost.org/libs/thread/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-thread-1.77.0"
    rebuild 2
    sha256 cellar: :any, big_sur: "1b082f7a4d9bdcda66f678184f2c178a6b54255292b15133eb9131bc798a7279"
  end

  depends_on "boost-config" => :build

  depends_on "boost-atomic"

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-thread", "cxxflags=-std=c++14", "stage"

    %w[config atomic].each do |d|
      f = Formula["boost-#{d}"]
      Pathname.glob(f.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }
      Pathname.glob(f.lib/"lib*").each { |l| rm_rf "stage/lib/#{l.basename}" }
    end

    prefix.install "stage/lib"
    prefix.install "libs/thread/include"

    Pathname.glob(lib/shared_library("*")).each { |l| MachO::Tools.add_rpath(l, rpath) }
  end

  test do
    system "echo"
  end
end
