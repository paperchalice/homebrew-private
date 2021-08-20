class BoostLocale < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/locale/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-locale-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "070eec433d5c2d15c9327056d11128f51a911871e6b8c24037e563df2550ed92"
  end

  depends_on "boost-atomic"    => :build
  depends_on "boost-config"    => :build
  depends_on "boost-chrono"    => :build
  depends_on "boost-container" => :build
  depends_on "boost-system"    => :build
  depends_on "boost-thread"    => :build

  depends_on "boost-chrono"
  depends_on "boost-container"
  depends_on "boost-system"
  depends_on "boost-thread"
  depends_on "icu4c"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh", "--with-icu=#{Formula["icu4c"].prefix}"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[atomic config chrono container system thread].each do |d|
      f = Formula["boost-#{d}"]
      Pathname.glob(f.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }
      Pathname.glob(f.lib/"lib*").each { |l| rm_rf "stage/lib/#{l.basename}" }
    end

    prefix.install "stage/lib"
    prefix.install "libs/#{boost_name}/include"

    Pathname.glob(lib/shared_library("*")).each { |l| MachO::Tools.add_rpath(l, rpath) }
  end

  test do
    system "echo"
  end
end
