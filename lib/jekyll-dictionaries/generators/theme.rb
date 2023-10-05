require 'delegate'

module JekyllDictionaries
  module Generators
    class Theme
      attr_reader :site, :theme
      def initialize(site)
        @site = site
      end

      def generate
        add_includes
        add_layouts
      end

      protected

      def theme
        @theme ||= Jekyll::Theme.new("jekyll-dictionaries")
      end

      def add_includes
        @site.includes_load_paths << theme.includes_path
      end

      def add_layouts
        layouts_path = theme.layouts_path
        wrap_custom_theme do
          entries_in(layouts_path).each do |layout_file|
            @site.layouts[theme_file_name(layout_file)] ||= Jekyll::Layout.new(@site, layouts_path, layout_file)
          end
        end
      end

      def wrap_custom_theme
        site_theme = @site.theme
        @site.theme = theme
        yield
        @site.theme = site_theme
      end

      def entries_in(dir)
        entries = []
        within(dir) do
          entries = Jekyll::EntryFilter.new(@site).filter(Dir["**/*.*"])
        end
        entries
      end

      def within(directory)
        return unless File.exist?(directory)

        Dir.chdir(directory) { yield }
      end

      def theme_file_name(file)
        file.split(".")[0..-2].join(".")
      end
    end
  end
end