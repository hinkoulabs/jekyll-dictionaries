# frozen_string_literal: true

require "jekyll"
require "jekyll-dictionaries/generator"

module JekyllDictionaries
  def self.root
    File.dirname __dir__
  end
end
