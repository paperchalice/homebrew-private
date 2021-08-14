class BoostMath < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/math/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.bz2"
  sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"
  license "BSL-1.0"

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-math", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    %w[math cstdfloat.hpp math_fwd.hpp].each { |h| (include/"boost").install "boost/#{h}"}
  end

  test do
    system "echo"
  end
end
