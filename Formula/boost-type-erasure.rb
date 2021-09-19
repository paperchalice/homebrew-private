class BoostTypeErasure < Formula
  desc "Runtime polymorphism in C++"
  homepage "https://boost.org/libs/type_erasure/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-type-erasure-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "e9fa3d30a86a10502e28007e0f92da86598b87a8bd173b1674d6cd35e75e5b32"
  end

  depends_on "boost-atomic" => :build
  depends_on "boost-chrono" => :build
  depends_on "boost-config" => :build
  depends_on "boost-system" => :build
  depends_on "boost-thread" => :build

  depends_on "boost-chrono"
  depends_on "boost-system"
  depends_on "boost-thread"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh"
    system "./b2", "--with-#{boost_name}", "cxxflags=-std=c++14", "stage"

    %w[atomic config chrono system thread].each do |d|
      f = Formula["boost-#{d}"]
      Pathname.glob(f.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }
      Pathname.glob(f.lib/"lib*").each { |l| rm_rf "stage/lib/#{l.basename}" }
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
