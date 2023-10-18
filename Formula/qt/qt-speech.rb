class QtSpeech < Formula
  desc "Qt text-to-speech support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.0/submodules/qtspeech-everywhere-src-6.4.0.tar.xz"
  sha256 "873bc22096a8d01b1fcde148d5df3542dfa391ef76b8dde1cd2f6fbf87183df7"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    "LGPL-3.0-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-speech-6.4.0"
    sha256 cellar: :any, monterey: "aec1fc2eca0f596f1c0b73a4c560d7126409a768e341d3b3e768765a777e997c"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "qt-multimedia"

  # TODO: depends_on "flite"
  # TODO: depends_on "speech-dispatcher"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  test do
    system "echo"
  end
end
