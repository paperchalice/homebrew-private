class Openj9Jre < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse/openj9/archive/refs/tags/openj9-0.26.0.tar.gz", using: :nounzip
  sha256 "ffb6a76161638d2a64b731774d170eccfd77ad738a31221ee32b57d9cd27211b"
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
  depends_on "pkg-config" => :build

  depends_on "fontconfig"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  resource "boot-jdk" do
    url "https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_mac_hotspot_16.0.1_9.tar.gz"
    sha256 "3be78eb2b0bf0a6edef2a8f543958d6e249a70c71e4d7347f9edb831135a16b8"
  end

  resource "omr" do
    url "https://github.com/eclipse/openj9-omr.git",
    tag:      "openj9-0.26.0",
    revision: "162e6f729733666e22726ce5326f5982bb030330"
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk16.git",
    branch:   "v0.26.0-release",
    revision: "cea22090ecf368eb47141dbbf882dcaa7afc1e15"
  end

  resource "openj9" do
    url "https://github.com/eclipse/openj9.git",
    tag:      "openj9-0.26.0",
    revision: "b4cc246d9d2362346bc567861e6e0e536da3f390"
  end

  def install
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    resource("openj9").stage buildpath/"openj9"
    resource("boot-jdk").stage buildpath/"boot-jdk"

    config_args = %W[
      --with-boot-jdk=#{buildpath}/boot-jdk/Contents/Home
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-sysroot=#{MacOS.sdk_path}

      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ENV.delete "_JAVA_OPTIONS"
    ENV["CMAKE_CONFIG_TYPE"] = "Release"

    system "bash", "./configure", *config_args
    system "make", "legacy-jre-image", "-j"

    jre = Dir["build/*/images/*"].first
    libexec.install jre => "openj9.jre"
    bin.install_symlink Dir[libexec/"openj9.jre/Contents/Home/bin/*"]
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openj9.jre /Library/Java/JavaVirtualMachines/openj9.jre
    EOS
  end

  test do
    system bin/"java", "-version"
  end
end
