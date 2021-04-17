class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse/openj9/archive/refs/tags/openj9-0.25.0.tar.gz",
    using: :nounzip
  sha256 "ad1349d3f6831702ef7cbf0f91998b94a0d8d4a95267f22f659a439762dfe7f2"
  license any_of: [
    "EPL-2.0",
    "Apache-2.0",
    { "GPL-2.0-or-later" => { with: "Classpath-exception-2.0" } },
    { "GPL-2.0-or-later" => { with: "OpenJDK-assembly-exception-1.0" } },
  ]

  livecheck do
    url :stable
    regex(/^openj9-(\d+(?:\.\d+)+)$/i)
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "nasm" => :build if Hardware::CPU.intel?
  depends_on "ninja" => :build
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on "fontconfig"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  resource "omr" do
    url "https://github.com/eclipse/openj9-omr/archive/refs/tags/openj9-0.25.0.tar.gz"
    sha256 "c8a2baaabf051e535ed211415a27634a2e4689f576d6d099e28ceab9ff1837c0"
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk16.git",
    branch:   "v0.25.0-release",
    revision: "0c11227a21ace48b7c978e29a347822912a6df9c"
  end

  def install
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    mkdir "openj9"
    system "tar", "-xf", "openj9-openj9-#{version}.tar.gz",
      "--strip-components", "1", "-C", buildpath/"openj9"

    config_args = %W[
      --with-boot-jdk=#{Formula["openjdk"].libexec/"openjdk.jdk/Contents/Home"}
      --with-native-debug-symbols=none
      --with-sysroot=#{MacOS.sdk_path}

      --with-vendor-name=homebrew
      --with-vendor-url=brew.sh

      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system

      --enable-ddr=no
      --enable-dtrace
      --enable-full-docs=no
    ]

    ENV.delete "_JAVA_OPTIONS"
    ENV["ASM_NASM"] = Formula["nasm"].bin/"nasm" if MacOS.version <= :mojave
    ENV["CMAKE_CONFIG_TYPE"] = "Release"

    system "bash", "./configure", *config_args
    system "make", "all", '"EXTRA_CMAKE_ARGS=-DOMR_SEPARATE_DEBUG_INFO=OFF"', "-j"

    jdk = Dir["build/*/images/jdk-bundle/*"].first
    libexec.install jdk => "openj9.jdk"
    rm libexec/"openj9.jdk/Contents/Home/lib/src.zip"
    rm_rf Dir.glob(libexec/"openj9.jdk/Contents/Home/**/*.dSYM")

    bin.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/include/darwin/*.h"]
    share.install_symlink libexec/"openj9.jdk/Contents/Home/man"
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9.jdk
    EOS
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
