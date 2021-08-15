class BoostLog < Formula
  desc "Make logging significantly easier"
  homepage "https://boost.org/libs/log/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  depends_on "boost-config" => :build
  depends_on "pkg-config"   => :build

  depends_on "boost-atomic"
  depends_on "boost-chrono"
  depends_on "boost-filesystem"
  depends_on "boost-regex"
  depends_on "boost-thread"
  depends_on "icu4c"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh", "--with-icu=#{Formula["icu4c"].prefix}"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[config atomic chrono filesystem regex thread].each do |d|
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
