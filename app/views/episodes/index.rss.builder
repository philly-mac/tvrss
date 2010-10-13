xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "TV Shows RSS"
    if @show
      xml.description "#{@show.name} Episodes"
    else
      fmt = "%a, %d/%m/%Y"
      xml.description "List of episodes for your shows between #{@from_date.strftime(fmt)} and #{@to_date.strftime(fmt)}"
    end

    @episodes.each do |episode|
      show = episode.show
      show_tag = "S#{Episode.pad_num(episode.season)}E#{Episode.pad_num(episode.season_episode)}"
      show_name = "#{episode.show.name} #{show_tag}"

      xml.item do
        xml.link episode.url
        xml.title "#{show_name} | #{episode.title}"
        xml.description <<EOF
          #{show_tag}<br />
          Air date: #{episode.air_date.strftime("%d/%m/%Y") if episode.air_date}<br />
          Status: #{show.show_status}
          <br /><br />
          #{link_to(show.name, show.url)}<br />
          #{link_to('isohunt', "http://isohunt.com/torrents/?ihq=#{CGI.escape(show_name)}", :target => '_blank')}
          #{link_to('thepiratebay', "http://thepiratebay.org/search/#{CGI.escape(show_name)}", :target => '_blank')}
EOF
        xml.pubDate episode.air_date.to_s if episode.air_date
      end
    end
  end
end
