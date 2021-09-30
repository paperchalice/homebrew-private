class QtShaderTools < Formula
  desc "Provide the producer functionality for the shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qtshadertools-everywhere-src-6.2.0.tar.xz"
  sha256 "5f66d43610a3a6739fc360d836a2c045135107c0ecd40eb3ed18ce5f3dd79c42"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtshadertools.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-shader-tools-6.2.0-rc2"
    sha256 cellar: :any, big_sur: "e89055c4c08f97a02fda083c196dbe2a83b91b93b1c9d8e28a152cfd0a1006da"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

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
