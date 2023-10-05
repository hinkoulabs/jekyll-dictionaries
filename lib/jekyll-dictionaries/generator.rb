require_relative 'pages/dictionary'
require_relative 'pages/dictionary_api'

require_relative 'generators/dictionaries'
require_relative 'generators/theme'

module JekyllDictionaries
  class Generator < Jekyll::Generator
    CONFIG = {
      'pages' => {
        'dictionary' => {
          'layout' => 'dictionary',
          'permalink' => 'dictionaries/:name'
        },
        'dictionary_api' => {
          'layout' => 'dictionary_api',
          'permalink' => 'api/dictionaries/:name.json'
        }
      }
    }

    safe true

    def generate(site)
      @site = site

      Generators::Theme.new(site).generate

      dictionaries = Generators::Dictionaries.new(site).generate

      dictionaries.each do |dictionary|
        build_dictionary_pages(dictionary)
      end
    end

    protected

    def config
      @config ||= Jekyll::Utils.deep_merge_hashes(CONFIG, @site.config["dictionaries"] || {})
    end

    def build_dictionary_pages(dictionary)
      api_page = Pages::DictionaryApi.new(@site, dictionary, config['pages']['dictionary_api'])
      doc_page = Pages::Dictionary.new(@site, dictionary, config['pages']['dictionary'])

      api_page.related_page = doc_page
      doc_page.related_page = api_page

      @site.pages << api_page
      @site.pages << doc_page
    end
  end
end