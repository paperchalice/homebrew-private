class BoostMultiprecision < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/multiprecision/"
  url "https://github.com/boostorg/multiprecision.git",
    tag:      "boost-1.77.0",
    revision: "e7c501f72462e0bf40c3ee4bbde990fc5aa0101c"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-multiprecision-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "19da5179c2fc1a621df501cc0e1a6d71a41e533a1db4e94036571503486e9637"
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
