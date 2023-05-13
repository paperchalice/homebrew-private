class QtWebEngine < Formula
  include Language::Python::Virtualenv

  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtwebengine-everywhere-src-6.5.0.tar.xz"
  sha256 "2a10da34a71b307e9ff11ec086455dd20b83d5b0ee6bda499c4ba9221e306f07"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-web-engine-6.2.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "99c778ca08bec64fdb86fe282aaec81f75824cf092851731b6f3daa295a3ea60"
  end

  keg_only "qt part"

  depends_on "cmake"   => [:build, :test]
  depends_on "ninja"   => :build
  depends_on "node"    => :build
  depends_on "perl"    => :build
  depends_on "pkgconf" => :build
  depends_on "python"  => :build
  depends_on "six"     => :build

  depends_on "abseil"
  depends_on "brotli"
  depends_on "ffmpeg@4"
  depends_on "jsoncpp"
  depends_on "libavif"
  depends_on "minizip"
  depends_on "openh264"
  depends_on "qt"
  depends_on "re2"
  depends_on "snappy"
  # TODO: depends_on "qt-base"
  # TODO: depends_on "qt-declarative"
  # TODO: depends_on "qt-positioning"
  # TODO: depends_on "qt-tools"
  # TODO: depends_on "qt-web-channel"
  depends_on "woff2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  patch :DATA

  def copy_brew
    qt = Formula["qt"]

    mkdir_p lib/"cmake/Qt#{version.major}"
    mkdir_p lib/"metatypes"
    mkdir_p share/"qt/modules"
    mkdir_p share/"qt/qml"
    mkdir_p share/"qt/mkspecs/modules"

    (lib/"cmake/Qt#{version.major}").install Dir["cmake/Find*"]
    cp_r qt.lib.glob("QtWebEngine*"), lib
    cp_r (qt.lib/"cmake").glob("qt#{version.major}webengine*"), lib/"metatypes"
    cp_r (qt.lib/"metatypes").glob("Qt#{version.major}WebEngine*"), lib/"cmake"
    cp_r (qt.pkgshare/"modules").glob("WebEngine*"), share/"qt/modules"
    cp_r (qt.pkgshare/"mkspecs/modules").glob("qt_lib_webengine*"), share/"qt/mkspecs/modules"
    cp_r (qt.pkgshare/"qml").glob("QtWebEngine*"), share/"qt/qml"
  end

  def real_install
    python = "python3.11"
    # Install python dependencies for QtWebEngine
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)

    inreplace "src/3rdparty/chromium/build/toolchain/apple/toolchain.gni",
        'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    cd "src/3rdparty/chromium" do
      inreplace "third_party/zlib/zconf.h", "!defined(CHROMIUM_ZLIB_NO_CHROMECONF)", "0"
      inreplace "third_party/pdfium/core/fxcodec/icc/icc_transform.h",
                "#include <lcms2.h>",
                "#define CMS_NO_REGISTER_KEYWORD 1\n#include <lcms2.h>"
      inreplace "third_party/libpng/pnglibconf.h", "#include", "//"
    end

    cd "src/3rdparty/chromium/build/linux/unbundle" do
      # absl_algorithm
      # absl_base
      # absl_cleanup
      # absl_container
      # absl_debugging
      # absl_flags
      # absl_functional
      # absl_hash
      # absl_log
      # absl_log_internal
      # absl_memory
      # absl_meta
      # absl_numeric
      # absl_random
      # absl_status
      # absl_strings
      # absl_synchronization
      # absl_time
      # absl_types
      # absl_utility
      syslibs = %w[
        brotli
        crc32c
        dav1d
        double-conversion
        flac
        jsoncpp
        libaom
        libavif
        openh264
        woff2
      ]
      inreplace "./brotli.gn", "/usr", HOMEBREW_PREFIX
      system python, "./replace_gn_files.py", "--system-libraries", *syslibs
    end

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -D FEATURE_webengine_system_ffmpeg=ON
      -D FEATURE_webengine_system_icu=ON
      -D FEATURE_webengine_system_re2=ON
      -D FEATURE_webengine_system_snappy=ON
      -D FEATURE_webengine_spellchecker=ON
      -D FEATURE_webengine_kerberos=ON
      -D FEATURE_webengine_spellchecker=ON

      -D FEATURE_pdf_v8=ON
      -D FEATURE_pdf_xfa=ON
      -D FEATURE_pdf_xfa_bmp=ON
      -D FEATURE_pdf_xfa_gif=ON
      -D FEATURE_pdf_xfa_png=ON
      -D FEATURE_pdf_xfa_tiff=ON

      -S .
      -G Ninja
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  def install
    # copy_brew
    real_install
  end

  test do
    system "echo"
  end
end

__END__
diff --git a/src/core/CMakeLists.txt b/src/core/CMakeLists.txt
index 61bf707..a3bbb78 100644
--- a/src/core/CMakeLists.txt
+++ b/src/core/CMakeLists.txt
@@ -454,6 +454,59 @@ foreach(arch ${archs})
                 use_external_popup_menu=false
                 angle_enable_vulkan=false
             )
+            list(APPEND gnArgArg
+                use_cups=true
+                use_gio=false
+                use_gnome_keyring=false
+                use_bundled_fontconfig=false
+                enable_session_service=false
+                is_cfi=false
+                use_glib=false
+                use_bluez=false
+                use_vaapi=false
+            )
+            set(systemLibs libjpeg libpng freetype harfbuzz libevent libwebp libxml
+                opus snappy libvpx icu ffmpeg re2 lcms2
+            )
+            foreach(slib ${systemLibs})
+                extend_gn_list(gnArgArg
+                    ARGS use_system_${slib}
+                    CONDITION QT_FEATURE_webengine_system_${slib}
+                )
+            endforeach()
+            extend_gn_list(gnArgArg
+                ARGS use_system_libxslt
+                CONDITION QT_FEATURE_webengine_system_libxml
+            )
+            extend_gn_list(gnArgArg
+                ARGS icu_use_data_file
+                CONDITION NOT QT_FEATURE_webengine_system_icu
+            )
+            extend_gn_list(gnArgArg
+                ARGS use_system_zlib use_system_minizip
+                CONDITION QT_FEATURE_webengine_system_zlib AND QT_FEATURE_webengine_system_minizip
+            )
+            extend_gn_list(gnArgArg
+                ARGS pdfium_use_system_zlib
+                CONDITION QT_FEATURE_webengine_system_zlib
+            )
+            extend_gn_list(gnArgArg
+                ARGS pdfium_use_system_libpng skia_use_system_libpng
+                CONDITION QT_FEATURE_webengine_system_libpng
+            )
+
+            if(QT_FEATURE_webengine_kerberos)
+                list(APPEND gnArgArg
+                     external_gssapi_include_dir="${GSSAPI_INCLUDE_DIRS}/gssapi"
+                )
+            endif()
+
+            if(CMAKE_CROSSCOMPILING AND cpu STREQUAL "arm")
+                check_thumb(armThumb)
+                if(NOT armThumb AND NOT QT_FEATURE_system_ffmpeg)
+                    list(APPEND gnArgArg media_use_ffmpeg=false use_webaudio_ffmpeg=false)
+                endif()
+            endif()
         endif()
 
         if(NOT CLANG)
diff --git a/src/pdf/CMakeLists.txt b/src/pdf/CMakeLists.txt
index ed2da10..5ebca2b 100644
--- a/src/pdf/CMakeLists.txt
+++ b/src/pdf/CMakeLists.txt
@@ -123,6 +123,18 @@ foreach(arch ${archs})
         endif()
         if(MACOS)
             list(APPEND gnArgArg angle_enable_vulkan=false)
+            extend_gn_list(gnArgArg
+                ARGS use_system_icu
+                CONDITION QT_FEATURE_webengine_system_icu
+            )
+            extend_gn_list(gnArgArg
+                ARGS pdfium_use_system_zlib
+                CONDITION QT_FEATURE_webengine_system_zlib
+            )
+            extend_gn_list(gnArgArg
+                ARGS pdfium_use_system_libpng
+                CONDITION QT_FEATURE_webengine_system_libpng
+            )
         endif()
         if(IOS)
             extend_gn_list(gnArgArg
--- a/src/3rdparty/chromium/build/config/linux/pkg-config.py
+++ b/src/3rdparty/chromium/build/config/linux/pkg-config.py
@@ -109,7 +109,7 @@ def main():
   # If this is run on non-Linux platforms, just return nothing and indicate
   # success. This allows us to "kind of emulate" a Linux build from other
   # platforms.
-  if "linux" not in sys.platform:
+  if "darwin" not in sys.platform:
     print("[[],[],[],[],[]]")
     return 0
 
@@ -129,6 +129,7 @@ def main():
   parser.add_option('--version-as-components', action='store_true',
                     dest='version_as_components')
   (options, args) = parser.parse_args()
+  options.sysroot = None
 
   # Make a list of regular expressions to strip out.
   strip_out = []
