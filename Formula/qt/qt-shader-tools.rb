class QtShaderTools < Formula
  desc "Provide the producer functionality for the shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.0/submodules/qtshadertools-everywhere-src-6.6.0.tar.xz"
  sha256 "3690327dc550144b8102be2bb7f6dc995ccbe3584041094ad021a83737ef9875"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtshadertools.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-shader-tools-6.6.0"
    sha256 cellar: :any, ventura: "b47c6bd4b0b15da3519e916fbf4ece4b1c7786bf81e3a946083a027ac4369972"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "ninja"   => :build
  depends_on "pkgconf" => :build

  depends_on "qt-base"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}
      -G Ninja
      -S .
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
