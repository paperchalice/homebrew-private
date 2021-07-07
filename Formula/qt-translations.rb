class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qttranslations-everywhere-src-6.1.2.tar.xz"
  sha256 "cf5dd3fed8f5f92f570c0d09bf635adbc7a40b748d48856a33109bc9c3781a1b"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-translations-6.1.2"
    sha256 cellar: :any_skip_relocation, big_sur: "58315cedf41ede09353bd8d497e54cbc41b6260b3e35f9b07ea1e51e946d9a3c"
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
