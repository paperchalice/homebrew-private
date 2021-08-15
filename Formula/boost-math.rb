class BoostMath < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/math/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-math-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "85c3621353ee1305dc8000faafb3529e965811d6578b5ccb1b1beeda81cc4662"
  end

  depends_on "boost-config" => :build

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[config].each do |d|
      f = Formula["boost-#{d}"]
      Pathname.glob(f.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }
      Pathname.glob(f.lib/"lib*").each { |l| rm_rf "stage/lib/#{l.basename}" }
    end

    prefix.install "stage/lib"
    prefix.install "libs/#{boost_name}/include"
  end

  test do
    system "echo"
  end
end
