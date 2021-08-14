class BoostAtomic < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/atomic/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.bz2"
  sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-atomic-1.77.0"
    sha256 cellar: :any, big_sur: "9cf1a1814602697f63c7141660ec95835ffd38b04a7af354568260754aed83a8"
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-atomic", "stage"

    %w[boost_headers Boost].each { |d| rm_rf "stage/lib/cmake/#{d}-#{version}" }
    rm "stage/lib/cmake/BoostDetectToolset-#{version}.cmake"
    prefix.install "stage/lib"
    (include/"boost").install "boost/atomic"
  end

  test do
    system "echo"
  end
end
