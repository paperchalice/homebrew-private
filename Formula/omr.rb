class Omr < Formula
  desc "Reliable components for building language runtimes"
  homepage "https://www.eclipse.org/omr/"
  url "https://github.com/eclipse/omr/archive/refs/tags/omr-0.1.0.tar.gz"
  sha256 "f956ca493e4089ce98be9651a7d3378cc43625bc8d24660195b8940e755eb797"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "libpng" => :test

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } + %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DOMR_DDR=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system bin/"omr_ddrgen", Formula["libpng"].lib/"libpng.dylib"
  end
end
