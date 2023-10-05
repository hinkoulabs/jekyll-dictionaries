module JekyllDictionaries
  module Pages
    class Dictionary < Jekyll::Page
      attr_accessor :type
      attr_reader :related_page

      def initialize(site, dic, default_opts)
        @site = site # the current site instance.
        @base = site.source # path to the source directory.
        @dir = dic.filename # the directory the page will reside in.

        add_scope_data

        # All pages have the same filename, so define attributes straight away.
        @basename = dic.filename # filename without the extension.
        @name = dic.content['name'] || dic.filename # basically @basename + @ext.

        # Initialize data hash with a key pointing to all posts under current category.
        # This allows accessing the list in a template via `page.linked_docs`.
        @data = {
          'content' => dic.content,
          'scope' => @type
        }

        # Look up front matter defaults scoped to type `dictionary`, if given key
        # doesn't exist in the `data` hash.
        data.default_proc = proc do |_, key|
          (default_opts || {})[key]
        end
      end

      def related_page=(page)
        @related_page = page
        @data['related_page'] = @related_page
      end

      def add_scope_data
        @type = :dictionary
        @ext = '.html'
      end

      # Placeholders that are used in constructing page URL.
      def url_placeholders
        {
          :path => @dir,
          :name => @dir,
          :basename => basename,
          :output_ext => output_ext,
        }
      end
    end
  end
end