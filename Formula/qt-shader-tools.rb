class QtShaderTools < Formula
  desc "Provide the producer functionality for the shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.3/submodules/qtshadertools-everywhere-src-6.1.3.tar.xz"
  sha256 "a2b2073f825432e81f5011f966c9e0f03a4c57024f15c3c2829a97de5f47b3b2"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtshadertools.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-shader-tools-6.1.3"
    sha256 cellar: :any, big_sur: "09c593399f421e6259625c5f0dedc973df6e759147682dc0aac701e42dddefe4"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "qt-base"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end
  end

  test do
    (testpath/"shader.frag").write <<~EOS
      #version 440

      layout(location = 0) in vec2 v_texcoord;
      layout(location = 0) out vec4 fragColor;
      layout(binding = 1) uniform sampler2D tex;

      layout(std140, binding = 0) uniform buf {
          float uAlpha;
      };

      void main()
      {
          vec4 c = texture(tex, v_texcoord);
          fragColor = vec4(c.rgb, uAlpha);
      }
    EOS

    system bin/"qsb", "-o", "shader.frag.qsb", "shader.frag"
    assert_predicate testpath/"shader.frag.qsb", :exist?
  end
end
