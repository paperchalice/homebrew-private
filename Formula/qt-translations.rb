class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qttranslations-everywhere-src-6.1.1.tar.xz"
  sha256 "6cf3d191335a6b3a64864e7ba41819e7be461d1d2861d643babe836f81d4c393"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-translations-6.1.1"
    sha256 cellar: :any_skip_relocation, big_sur: "e1841c806344c5db3fcbfe792e6d3c9968805324fb8b9af86943bc56f168491e"
  end

  depends_on "cmake"    => :build
  depends_on "perl"     => :build
  depends_on "qt-tools" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      .
    ]
    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"
  end

  test do
    assert_predicate share/"qt/translations", :exist?
  end
end
