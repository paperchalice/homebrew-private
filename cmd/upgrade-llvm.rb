# frozen_string_literal: true

require "formula"
require "open-uri"
require "utils/inreplace"

module Homebrew
  module_function

  def upgrade_llvm
    v = `brew livecheck llvm`
    new_version = Version.new(v.scan(/\d+(?:\.\d+)+/).last)
    new_tag = "llvmorg-#{new_version}"
    old_tag = Formula["llvm-core"].stable.specs[:tag]
    old_rev = Formula["llvm-core"].stable.specs[:revision]
    new_rev = URI.parse("https://github.com/llvm/llvm-project/releases/tag/#{new_tag}").open.read.match(%r{(?<=commit/)\w{40}}).to_s
    %w[
      llvm-core
      libc++ libc++abi compiler-rt polly
      clang flang lld lldb
    ].each do |n|
      f = Formula[n]
      Utils::Inreplace.inreplace f.path, old_tag, new_tag
      Utils::Inreplace.inreplace f.path, old_rev, new_rev
    end
  end
end
