# frozen_string_literal: true

require "formula"
require "open-uri"
require "utils/inreplace"

module Homebrew
  module_function

  def upgrade_qt
    v = `brew livecheck qt`
    new_version = Version.new(v.scan(/\d+(?:\.\d+)+/).last)

    url_template = "https://download.qt.io/official_releases/qt/#{new_version.major}.#{new_version.minor}/#{new_version}/submodules/qt%s-everywhere-src-#{new_version}.tar.xz"
    %w[
      3d base charts datavis3d declarative
      imageformats lottie networkauth quick-controls2
      quick-timeline quick3d scxml shader-tools svg tools translations
    ].each do |c|
      f = Formula["qt-#{c}"]
      old_url = f.stable.url
      name = old_url.match(/(?<=qt)[a-z0-9]+/)
      new_url = url_template % name
      Utils::Inreplace.inreplace f.path, old_url.to_s, new_url

      new_sha256 = URI.parse("#{new_url}.mirrorlist").open.read.match(/[0-9a-f]{64}/)
      Utils::Inreplace.inreplace f.path, /sha256 "[0-9a-f]{64}"/, "sha256 \"#{new_sha256}\""
    end
  end
end
