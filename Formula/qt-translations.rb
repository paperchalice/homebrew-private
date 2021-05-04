class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.4/submodules/qttranslations-everywhere-src-6.0.4.tar.xz"
  sha256 "f58fdd4ce05a6f1e0530a28b1dcb2d2269497ee27dfd6a73584a5920b0ad9933"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-translations-6.0.3"
    sha256 cellar: :any_skip_relocation, big_sur: "92c187d5ed631e6e89f5d5e1aaab67ca65cbaa08d9ed1c134f3ea80d25db04df"
  end

  depends_on "cmake" => :build
  depends_on "qt-tools" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      .
    ]
    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    Pathname.glob(share/"qt/translations/*_zh_CN.qm") do |trans|
      (share/"qt/translations").install_symlink trans => "#{trans.basename("_zh_CN.qm")}_zh_Hans_CN.qm"
    end
  end

  test do
    assert_predicate share/"qt/translations", :exist?
  end
end
