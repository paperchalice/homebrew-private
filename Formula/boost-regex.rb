class BoostRegex < Formula
  desc "Regex library"
  homepage "https://boost.org/libs/regex/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-regex-1.77.0"
    sha256 cellar: :any, big_sur: "87c6fbdb09c37f0b4945ebe3c6d76bebccf80b22e61276bcef1cd5606cfa8562"
  end

  depends_on "boost-config" => :build
  depends_on "pkgconf"   => :build

  depends_on "icu4c"

  def install
    boost_name = name.delete_prefix("boost-").sub("-", "_")

    system "./bootstrap.sh", "--with-icu=#{Formula["icu4c"].prefix}"
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
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
