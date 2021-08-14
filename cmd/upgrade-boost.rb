# frozen_string_literal: true

require "formula"
require "open-uri"
require "utils/inreplace"

module Homebrew
  module_function

  def upgrade_boost
    v = `brew livecheck boost`
    new_version = Version.new(v.scan(/\d+(?:\.\d+)+/).last)

    repo = Pathname.new(`brew --repo paperchalice/private`).dirname/"homebrew-private"
    boosts = Pathname.glob(repo/"Formula/boost-*").map { |f| f.basename(".rb").to_s }

    boosts.each do |c|
      f = Formula[c]
      url = f.stable.url.delete_suffix(".git")
      # new_rev = URI.parse("#{url}/releases/tag/#{new_tag}").open.read.match(%r{(?<=commit/)\w{40}}).to_s
      Utils::Inreplace.inreplace f.path, "boost-#{f.version}", "boost-#{new_version}"
      Utils::Inreplace.inreplace f.path, "boost-#{f.version}", "boost-#{new_version}"
    end
  end
end
