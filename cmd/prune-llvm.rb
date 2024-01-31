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
      rm_rf f unless f.to_s.end_with? "dylib"
    end
  end
end
