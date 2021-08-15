class BoostUnits < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/units/"
  url "https://github.com/boostorg/units.git",
    tag:      "boost-1.77.0",
    revision: "45787015dd8c11653eb988260acf05c4af9d42e5"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-units-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "11a526407bcae83e64b9658a8ce8b374787137ae7d163573d841d35ccc803b30"
  end

  def install
    prefix.install "include"
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
