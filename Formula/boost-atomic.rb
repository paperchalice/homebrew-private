class BoostAtomic < Formula
  desc "Atomic data types and operations"
  homepage "https://boost.org/libs/atomic/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-atomic-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "aefbaf7b076b7ac122fa968132fc508d1e3bb4d9d5dfcb8cd45cfbdda72fcfff"
  end

  depends_on "boost-config" => :build

  depends_on "boost-assert"
  depends_on "boost-type-traits"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[config].each do |d|
      f = Formula["boost-#{d}"]
      f.lib.glob("cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }
      f.lib.glob("lib*").each { |l| rm_rf "stage/lib/#{l.basename}" }
    end

    prefix.install "stage/lib"
    prefix.install "libs/#{boost_name}/include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        boost::atomic<int> n{0};
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
