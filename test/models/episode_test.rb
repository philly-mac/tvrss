require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Episode Model" do
  it 'can be created' do
    @episode = Episode.new
    @episode.should.not.be.nil
  end
end
