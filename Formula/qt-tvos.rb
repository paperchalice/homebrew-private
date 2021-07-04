class QtTvos < Formula
  desc "Qt for tvOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/single/qt-everywhere-src-6.1.1.tar.xz"
  sha256 "6ac937aae4c7b5a3eac90ea4d13f31ded9f78ebc93007bb919fae65c58c808c3"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  keg_only "this is Qt SDK for tvOS"

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.9"
  depends_on "qt"
  depends_on :xcode

  uses_from_macos "perl"

  def install
    ENV.permit_arch_flags
    ENV.delete "HOMEBREW_SDKROOT"

    inreplace "qtbase/CMakeLists.txt", "FATAL_ERROR", ""

    xplatform = "macx-watchos-clang"
    config_args = %W[
      -release
      -prefix #{prefix}
      -xplatform #{xplatform}
      -qt-host-path
      #{Formula["qt"].prefix}
    ]

    system "./configure", *config_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm_rf Pathname.glob("#{bin}/*.app")
    rm bin/"qt-cmake-private-install.cmake"
    rm_rf bin/"target_qt.conf"
    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", HOMEBREW_SHIMS_PATH/"mac/super", "/usr/bin"
    (libexec/"target_qt.conf").write <<~EOS
      [DevicePaths]
      Prefix=/#{name}/#{prefix.basename}
      [Paths]
      Prefix=#{prefix}
      HostPrefix=#{Formula["qt"].prefix}
      HostData=#{prefix}
      Sysroot=
      SysrootifyPrefix=false
      TargetSpec=#{xplatform}
      HostSpec=macx-clang
    EOS
    libexec.install bin/"qmake"
    bin.write_exec_script libexec/"qmake"
  end

  test do
    (testpath/"test.pro").write <<~EOS
      QT       += core
      TARGET = test
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <QDebug>
      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        return 0;
      }
    EOS

    system bin/"qmake"
    assert_predicate testpath/"test.xcodeproj", :exist?
  end
end
