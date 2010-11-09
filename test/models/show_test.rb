require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Show Model" do
  it 'can be created' do
    @show = Show.new
    @show.should.not.be.nil
  end
end
