require_relative 'dictionary'

module JekyllDictionaries
  module Pages
    class DictionaryApi < Dictionary
      def add_scope_data
        @type = :dictionary_api
        @ext = '.json'
      end
    end
  end
end