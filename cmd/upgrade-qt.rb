# frozen_string_literal: true

require "formula"
require "open-uri"
require "utils/inreplace"

module Homebrew
  module_function

  def upgrade_qt
    v = `brew livecheck qt`
    new_version = Version.new(v.scan(/\d+(?:\.\d+)+/).last)

    repo = Pathname.new(`brew --repo paperchalice/private`).dirname/"homebrew-private"
    qts = Pathname.glob(repo/"Formula/qt-*").map { |f| f.basename(".rb").to_s }
    qts.delete "qt-doc"

    url_template = "https://download.qt.io/official_releases/qt/#{new_version.major_minor}/#{new_version}/submodules/qt%s-everywhere-src-#{new_version}.tar.xz"
    qts.each do |c|
      f = Formula[c]
      old_url = f.stable.url
      name = old_url.match(/(?<=qt)[a-z0-9]+/)
      new_url = url_template % name
      Utils::Inreplace.inreplace f.path, old_url.to_s, new_url

      new_sha256 = URI.parse("#{new_url}.sha256").open.read.match(/[0-9a-f]{64}/).to_s
      Utils::Inreplace.inreplace f.path, f.stable.checksum.hexdigest, new_sha256
    end

    # upgrade qt-doc
    f = Formula["qt-doc"]
    old_url = f.stable.url
    new_url = "https://download.qt.io/official_releases/qt/#{new_version.major_minor}/#{new_version}/single/qt-everywhere-src-#{new_version}.tar.xz"
    Utils::Inreplace.inreplace f.path, old_url.to_s, new_url
    new_sha256 = URI.parse("#{new_url}.sha256").open.read.match(/[0-9a-f]{64}/).to_s
    Utils::Inreplace.inreplace f.path, f.stable.checksum.hexdigest, new_sha256
  end
end
