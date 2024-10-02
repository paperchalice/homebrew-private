class BoostIostreams < Formula
  desc "IOStream from boost"
  homepage "https://boost.org/libs/iostreams/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-iostreams-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "002cf24e152b9c2db6f4b0609dfec4ae47b485e98dde12c2c3ddc3ca319e274d"
  end

  depends_on "boost-config" => :build
  depends_on "pkgconf"      => :build

  depends_on "boost-config"

  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[config].each do |d|
      f = Formula["boost-#{d}"]
      f.lib.glob("cmake/*").each { |c| rm_r "stage/lib/cmake/#{c.basename}" }
      f.lib.glob("lib*").each { |l| rm_r "stage/lib/#{l.basename}" }
    end

    prefix.install "stage/lib"
    prefix.install "libs/#{boost_name}/include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
