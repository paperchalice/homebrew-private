class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qttranslations-everywhere-src-6.2.0.tar.xz"
  sha256 "5b4ecb1ee35363444f03b1eb10637d79af1d19be5a5cc53657dc0925a78b2240"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-translations-6.2.0"
    sha256 cellar: :any_skip_relocation, big_sur: "56a0042832fc0fb12d71c2f4ec3b39551d99f93e956c280abf5cb8dc3375482a"
  end

  depends_on "cmake"    => :build
  depends_on "perl"     => :build
  depends_on "qt-tools" => :build

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"
  end

  test do
    assert_predicate share/"qt/translations", :exist?
  end
end
