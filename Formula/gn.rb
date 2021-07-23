class Gn < Formula
  desc "Generate Ninja - Chromium's build system"
  homepage "https://gn.googlesource.com/gn/"
  url "https://gn.googlesource.com/gn.git",
    revision: "d565aa3e72dd9e81da9595ee8c9d7b24cb45c48b"
  version "1929"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gn-1.0.0"
    sha256 cellar: :any_skip_relocation, big_sur: "efee53db5825b39650cdb2d8e4cff23d00b7ab29790ae49a06b7a2ecce1d26d8"
  end

  depends_on "ninja"  => :build
  depends_on "python" => :build

  def install
    system "python3", "build/gen.py"
    system "ninja", "-C", "out/", "gn"
    bin.install "out/gn"
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
  end
end
