class Gn < Formula
  desc "Generate Ninja - Chromium's build system"
  homepage "https://gn.googlesource.com/gn/"
  url "https://gn.googlesource.com/gn.git"
  version "1936"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gn-1929"
    sha256 cellar: :any_skip_relocation, big_sur: "abe59752bfa4f223bee66a38811b6d331d3e5a183e7cbbef0f9eda26ab7c034b"
  end

  depends_on "ninja"  => :build
  depends_on "python" => :build

  def install
    system "python3", "build/gen.py"
    system "ninja", "-C", "out/", "gn"
    bin.install "out/gn"
    doc.install Dir["docs/*"]
    %w[autoload ftdetect ftplugin syntax].each { |v| (share/"vim/vimfiles").install "misc/vim/#{v}" }
    elisp.install "misc/emacs/gn-mode.el"
  end

  test do
    # Mock out a fake toolchain and project.
    (testpath/".gn").write <<~EOS
      buildconfig = "//BUILDCONFIG.gn"
    EOS

    (testpath/"BUILDCONFIG.gn").write <<~EOS
      set_default_toolchain("//:mock_toolchain")
    EOS

    (testpath/"BUILD.gn").write <<~EOS
      toolchain("mock_toolchain") {
        tool("link") {
          command = "echo LINK"
          outputs = [ "{{output_dir}}/foo" ]
        }
      }
      executable("hello") { }
    EOS

    cd testpath
    out = testpath/"out"
    system bin/"gn", "gen", out
    assert_predicate out/"build.ninja", :exist?,
      "Check we actually generated a build.ninja file"

    system bin/"gn", "--version"
  end
end
