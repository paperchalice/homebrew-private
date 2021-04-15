class Openj9 < Formula
  desc "Optimized Java Virtual Machine for OpenJDK"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/ibmruntimes/openj9-openjdk-jdk16.git",
    branch: "v0.25.0-release"
  version "0.25.0"
  license any_of: [
    "EPL-2.0",
    "Apache-2.0",
    "GPL-2.0-only" => { with: "Classpath-exception-2.0" },
  ]

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on "freetype"
  depends_on "openssl@1.1"

  def install
    java_options = ENV.delete("_JAVA_OPTIONS")
    ENV.prepend "PATH", "/usr/bin:"

    openj9_args = %w[
      -openj9-branch=v0.25.0-release
      -omr-branch=v0.25.0-release
    ]
    system "bash", "./get_source.sh", *openj9_args

    config_args = %W[
      --with-boot-jdk=#{Formula["openjdk"].prefix}
      --with-boot-jdk-jvmargs=#{java_options}
      --with-native-debug-symbols=none
    ]

    system "bash", "./configure", *config_args
    system "make", "all", "-j"

    jdk = Dir["build/*/images/jdk-bundle/*"].first
    libexec.install jdk => "openj9.jdk"
    bin.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/include/darwin/*.h"]
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9-11.jdk
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
