class BoostChrono < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/chrono/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-chrono-1.77.0"
    sha256 cellar: :any, big_sur: "4ff0eaf97cf891babf139f543b06a1fa6b74161a5f6625256aa1fe8588d17ba1"
  end

  depends_on "boost-config" => :build

  depends_on "boost-move"
  depends_on "boost-ratio"
  depends_on "boost-system"

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
