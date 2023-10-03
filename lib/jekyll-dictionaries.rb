# frozen_string_literal: true

require "jekyll"
require "jekyll-dictionaries/generator"

module JekyllDictionaries
  autoload :DictionaryPage, "jekyll-dictionaries/dictionary_page.rb"
  autoload :DictionaryApiPage, "jekyll-dictionaries/dictionary_api_page.rb"

  def self.root
    File.dirname __dir__
  end
end
