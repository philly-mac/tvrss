xml.instruct!
xml.rss "version" => "2.0" do
  xml.channel do
    xml.title "TV Shows RSS"
    if @show
      xml.description "#{@show.name} Episodes"
    else
      fmt = "%a, %d/%m/%Y"
      xml.description "List of episodes for your shows between #{@from_date.strftime(fmt)} and #{@to_date.strftime(fmt)}"
    end

    count = 1

    @episodes.each do |episode|
      show = episode.show
      show_tag = "S#{Episode.pad_num(episode.season)}E#{Episode.pad_num(episode.season_episode)}"
      show_name = "#{episode.show.name} #{show_tag}"

      show_tag_alt = "#{episode.season}x#{Episode.pad_num(episode.season_episode)}"
      show_name_alt = "#{episode.show.name} #{show_tag_alt}"

      xml.item do
        xml.link episode.url
        xml.title "#{count}) #{show_name} | #{episode.title}"
        xml.description <<EOF
          Air date: #{episode.air_date.strftime("%d/%m/%Y") if episode.air_date}<br />
          #{link_to(show.name, show.url)} - #{show.show_status}
          <br /><br />
          ORIG - #{link_to('isohunt', "http://isohunt.com/torrents/?ihq=#{CGI.escape(show_name)}", :target => '_blank')}
          #{link_to('thepiratebay', "http://thepiratebay.org/search/#{CGI.escape(show_name)}", :target => '_blank')}
          |
          ALT - #{link_to('isohunt', "http://isohunt.com/torrents/?ihq=#{CGI.escape(show_name_alt)}", :target => '_blank')}
          #{link_to('thepiratebay', "http://thepiratebay.org/search/#{CGI.escape(show_name_alt)}", :target => '_blank')}
EOF
        count += 1
      end
    end
  end
end

