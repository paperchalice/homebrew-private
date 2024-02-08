# frozen_string_literal: true

require "formula"
require "open-uri"

module Homebrew
  module_function

  def prune_llvm
    llvm = Formula["llvm"]

    llvm.prefix.children.each do |f|
      rm_rf f unless f.to_s.end_with? "lib"
    end

    llvm.lib.children.each do |f|
      zap = %w[MLIR, mlir, lldb, omp, unwind]
      rm_rf f unless f.to_s.end_with? "dylib"
      rm_rf f if zap.any? { |z| f.to_s.include? z }
    end
  end
end
