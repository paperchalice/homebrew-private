class BoostJson < Formula
  desc "C++ Json parser"
  homepage "https://boost.org/libs/json/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-json-1.77.0"
    sha256 cellar: :any, big_sur: "645795a74744a30ebdace009c8121f32423aee758c355e9df8995867953e200b"
  end

  depends_on "boost-config"    => :build
  depends_on "boost-container" => :build

  depends_on "boost-container"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[config container].each do |d|
      f = Formula["boost-#{d}"]
      f.lib.glob("cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }
      f.lib.glob("lib*").each { |l| rm_rf "stage/lib/#{l.basename}" }
    end

    prefix.install "stage/lib"
    prefix.install "libs/#{boost_name}/include"

    Pathname.glob(lib/shared_library("*")).each { |l| MachO::Tools.add_rpath(l, rpath) }
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
