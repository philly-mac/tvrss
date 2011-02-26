module ApplicationHelper
  def title_description(show, from_date = nil, to_date = nil, rss = false)
     if show
       if rss
         "#{show.name} Episodes <=> #{show.url}"
       else
         "#{link_to("#{show.name} Episodes", show.url)}<br /> #{link_to("rss", episode_path(show.id, :format => :rss))}"
      end
    else
      fmt = "%a, %d/%m/%Y"
      "List of episodes for your shows between #{from_date.strftime(fmt)} and #{to_date.strftime(fmt)}"
    end
  end

  def title(counter, episode)
    "#{counter}) #{episode_name(episode)} | #{episode.title}"
  end

  def show_name(episode)
    "#{search_name(episode.show)} #{episode_tag(episode)}"
  end

  def show_name_alt(episode)
    "#{search_name(episode.show)} #{episode_tag_alt(episode)}"
  end

  def search_name(show)
    show.search_as.present? ? show.search_as : show.name
  end

  def episode_tag(episode)
    "S#{Episode.pad_num(episode.season)}E#{Episode.pad_num(episode.season_episode)}"
  end

  def episode_tag_alt(episode)
    "#{episode.season}x#{Episode.pad_num(episode.season_episode)}"
  end

  def iso_link(show)
    "ORIG - #{link_to('isohunt', "http://isohunt.com/torrents/?ihq=#{CGI.escape(show_name(show))}", :target => '_blank')}"
  end

  def pirate_bay_link(show)
    link_to('thepiratebay', "http://thepiratebay.org/search/#{CGI.escape(show_name(show))}", :target => '_blank')
  end

  def iso_link_alt(show)
    "ALT - #{link_to('isohunt', "http://isohunt.com/torrents/?ihq=#{CGI.escape(show_name_alt(show))}", :target => '_blank')}"
  end

  def pirate_bay_link_alt(show)
    link_to('thepiratebay', "http://thepiratebay.org/search/#{CGI.escape(show_name_alt(show))}", :target => '_blank')
  end

  def description(episode)
    show = episode.show
    <<EOF
      Air date: #{episode.air_date.strftime("%d/%m/%Y") if episode.air_date}<br />
      #{link_to(show.name, show.url)} - #{show.genres} - #{show.show_status}
      <br /><br />
      #{iso_link(show)} #{pirate_bay_link(show)} | #{iso_link_alt(show)} #{pirate_bay_link_alt(show)}
EOF
  end
end
