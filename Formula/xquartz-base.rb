class XquartzBase < Formula
  desc "Base directory"
  homepage "https://www.xquartz.org/"
  url "https://github.com/XQuartz/XQuartz/archive/refs/tags/XQuartz-2.8.2.tar.gz"
  sha256 "050c538cf2ed39f49a366c7424c7b22781c9f7ebe02aa697f12e314913041000"
  license "APSL-2.0"

  def install
    system "echo", std_cmake_args
    system "false"
  end

  test do
    system bin/"font_cache"
  end
end
