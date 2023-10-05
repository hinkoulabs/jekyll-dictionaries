module JekyllDictionaries
  module Generators
    class Dictionaries
      DICT_REGEX = /^_(.*)/

      def initialize(site)
        @site = site
      end

      def generate
        build_dictionaries_from_data
      end

      protected

      def build_dictionaries_from_data
        @site.data['dictionaries'].inject([]) do |memo, (k, v)|
          # dictionary start with _
          m = k.match(DICT_REGEX)
          if m
            dict = v.merge('data' => [])

            name = m[1]

            folder = @site.data['dictionaries'][name]

            if (folder)
              dict['data'] = build_collections(folder)
            end

            memo << OpenStruct.new(filename: name, content: dict)
          end
          memo
        end
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
end