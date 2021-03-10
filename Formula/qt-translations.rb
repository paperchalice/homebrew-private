class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/submodules/qttranslations-everywhere-src-6.0.2.tar.xz"
  sha256 "6dcdcb8f03f4ca360618dd7422fb87c48b91a26b9e5e5e6f9917c047dbb8ad14"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-translations-6.0.2"
    sha256 cellar: :any_skip_relocation, big_sur: "7ce71f4191e3389b71e86a53802e645bb8f31d42e592e1d145d2c349fab09c1e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt-tools" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"
  end

  test do
    assert_predicate share/"qt/translations", :exist?
  end
end
