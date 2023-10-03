# frozen_string_literal: true

require "jekyll"
require "jekyll-dictionaries"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  SOURCE_DIR = File.expand_path("fixtures", __dir__)
  JEKYLL_SOURCE_DIR = File.expand_path("fixtures/jekyll", __dir__)
  DEST_DIR   = File.expand_path("dest",     __dir__)

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def jekyll_source_dir(*files)
    File.join(JEKYLL_SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  def snapshot_content(file)
    File.read(source_dir("snapshots/#{file}"))
  end

  def page_content(file)
    File.read(dest_dir(file))
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
