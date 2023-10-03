require_relative './dictionary_page'
require_relative './dictionary_api_page'

module JekyllDictionaries
  class Generator < Jekyll::Generator
    DICT_REGEX = /^_(.*)/

    safe true

    def generate(site)
      @site = site
      dicts = site.data['dictionaries'].inject([]) do |memo, (k, v)|
        # dictionary start with _
        m = k.match(DICT_REGEX)
        if m
          dict = v.merge('data' => [])

          name = m[1]

          folder = site.data['dictionaries'][name]

          if (folder)
            dict['data'] = build_collections(folder)
          end

          memo << OpenStruct.new(filename: name, content: dict)
        end
        memo
      end

      dicts.each do |dict|
        api_page = DictionaryApiPage.new(site, dict, config)
        doc_page = DictionaryPage.new(site, dict, config)

        api_page.related_page = doc_page
        doc_page.related_page = api_page

        site.pages << api_page
        site.pages << doc_page
      end
    end

    protected

    def config
      @config ||= @site.config["dictionaries"] || {}
    end

    def build_collections(folder_content)
      folder_content.inject([]) do |memo, (k, v)|
        if v.is_a?(Hash)
          # collection is detected
          if (v['type'] == 'collection')
            # set k as title if title is missing
            memo << { 'name' => v['name'] || k }.merge(v)
          else
            metadata = v['_metadata']
            # folder is detected
            memo
            folder = {
              'type' => 'folder',
              'name' => metadata ? metadata['name'] : k,
              'data' => build_collections(v.select { |kk, _| kk != '_metadata' })
            }
            memo << folder
          end
        end

        memo
      end
    end
  end
end