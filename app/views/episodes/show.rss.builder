xml.instruct!
xml.rss "version" => "2.0" do
  xml.channel do
    xml.title "TV Shows RSS"
    xml.description title_description(@show, @from_date,@to_date, true)

    counter = @episodes.size
    
    @episodes.each do |episode|
      xml.item do
        xml.title title(counter, episode)
        xml.link episode.url
        xml.description description(episode)
      end
      counter -= 1
    end
  end
end

