class Omr < Formula
  desc "Reliable components for building language runtimes"
  homepage "https://www.eclipse.org/omr/"
  url "https://github.com/eclipse/omr/archive/refs/tags/omr-0.1.0.tar.gz"
  sha256 "c8a2baaabf051e535ed211415a27634a2e4689f576d6d099e28ceab9ff1837c0"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "libpng" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system bin/"omr_ddrgen", Formula["libpng"].lib/"libpng.dylib"
  end
end
