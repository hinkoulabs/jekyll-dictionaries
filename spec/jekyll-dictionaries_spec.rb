# frozen_string_literal: true

RSpec.describe JekyllDictionaries do
  let(:overrides) { {} }
  let(:config) do
    Jekyll.configuration(Jekyll::Utils.deep_merge_hashes({
                                                           "full_rebuild" => true,
                                                           "source" => jekyll_source_dir,
                                                           "destination" => dest_dir,
                                                           "show_drafts" => false,
                                                           "url" => "http://example.org",
                                                           "name" => "My awesome site",
                                                           "author" => {
                                                             "name" => "Dr. Jekyll",
                                                           }
                                                         }, overrides))
  end
  let(:site) { Jekyll::Site.new(config) }
  let(:context) { make_context(:site => site) }
  let(:jekyll_env) { "development" }
  before(:each) do
    allow(Jekyll).to receive(:env).and_return(jekyll_env)
    site.process
  end

  it "has correct single translation page" do
    expect(page_content('dictionaries/single.html')).to eq(snapshot_content('pages/single.html'))
  end

  it "has correct multiple translation page" do
    expect(page_content('dictionaries/multiple.html')).to eq(snapshot_content('pages/multiple.html'))
  end

  it "has correct single translation api" do
    expect(page_content('api/dictionaries/single.json')).to eq(snapshot_content('api/single.json'))
  end

  it "has correct multiple translation api" do
    expect(page_content('api/dictionaries/multiple.json')).to eq(snapshot_content('api/multiple.json'))
  end
end
