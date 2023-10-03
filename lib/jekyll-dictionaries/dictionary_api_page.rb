require_relative './dictionary_page'

module JekyllDictionaries
  class DictionaryApiPage < DictionaryPage
    def add_scope_data
      @type = :dictionary_api
      @ext = '.json'
    end
  end
end