# frozen_string_literal: true

require "formula"
require "open-uri"

module Homebrew
  module_function

  def prune_gcc
    gcc = Formula["gcc"]

    gcc.prefix.children.each do |f|
      rm_rf f unless f.to_s.end_with? "lib"
    end

    (gcc.lib/"gcc").children.each do |f|
      rm_rf f unless f.to_s.end_with? "current"
    end

    (gcc.lib/"gcc/current").children.each do |f|
      rm_rf f unless f.to_s.end_with? ".dylib"
    end
  end
end
