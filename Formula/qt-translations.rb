class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.0/submodules/qttranslations-everywhere-src-6.1.0.tar.xz"
  sha256 "2affef9a0da9b61e8fc64ebbd515136b59c7392b789cd059ad134b26755dd073"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-translations-6.1.0"
    sha256 cellar: :any_skip_relocation, big_sur: "194439e75170fbdb00f2bc1c637e7e5d4ec31f4bd9ba570569930ff60680a12d"
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
