class OpenjdkJre < Formula
  desc "Java runtime environment"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk16u.git",
    tag:      "jdk-16.0.1-ga",
    revision: "ba7c640201ba77b7a6b727bbcdb1f936ebe4a964"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url "https://github.com/openjdk/jdk#{version.major}u/releases"
    strategy :page_match
    regex(/>\s*?jdk[._-]v?(\d+(?:\.\d+)*)-ga\s*?</i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/openjdk-jre-16.0.1"
    sha256 cellar: :any, big_sur: "dcaefb62d511b97dc06a5a8c3b0970ff6168393e3d3b038a175998ff2b83139f"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build

  resource "boot-jdk" do
    url "https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_mac_hotspot_16.0.1_9.tar.gz"
    sha256 "3be78eb2b0bf0a6edef2a8f543958d6e249a70c71e4d7347f9edb831135a16b8"
  end

  def install
    boot_jdk = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --with-boot-jdk=#{boot_jdk}/Contents/Home
      --with-jvm-variants=client
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --with-sysroot=#{MacOS.sdk_path}
    ]

    system "sh", "./configure", *args
    system "make", "mac-legacy-jre-bundle", "-j"

    jdk = Dir["build/*/images/jre-bundle/*"].first
    libexec.install jdk => "openjdk.jre"
  end

  test do
    system "echo"
  end
end
