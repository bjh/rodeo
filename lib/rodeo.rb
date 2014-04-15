require "rodeo/version"
require "rodeo/configuration"
require "rodeo/manifest"

module Rodeo
  def self.configuration
    yield(self) if block_given?
  end

  extend Configuration
end
