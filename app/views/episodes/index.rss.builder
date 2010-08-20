xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "TV RSS"
    xml.description "List of episodes for your shows"

    @episodes.each do |episode|
      xml.item do
        xml.title episode.show.name
        xml.description <<EOF
          #{episode.air_date.strftime("%d/%m/%Y")}<br />
          #{episode.title}

EOF
        xml.pubDate episode.air_date.to_s(:rfc822)
        xml.link episode.url
      end
    end
  end
end
