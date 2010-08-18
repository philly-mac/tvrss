class Episode
  include DataMapper::Resource

  belongs_to :show

  property :id,             Serial
  property :episode,        String
  property :season,         String
  property :product_number, String
  property :air_date,       Date
  property :url,            Text
  property :title,          String
  property :tvr_show_id,    String
  timestamps :at

  class << self
    def import_episodes(force = false, tvr_show_id = nil)
      shows = tvr_show_id ? Show.all(:tvr_show_id => tvr_show_id) : Show.all
      shows.each do |show|
        doc = Nokogiri::XML(open("http://services.tvrage.com/feeds/episode_list.php?sid=#{show.tvr_show_id}"))
        doc.css('Show Episodelist Season').each do |seasons|
          seasons.css("episode").each do |episode|
            epnum     = episode.css("epnum").first.content
            seasonnum = episode.css("seasonnum").first.content
            prodnum   = episode.css("prodnum").first.content
            airdate   = Date.parse(episode.css("airdate").first.content) rescue nil
            link      = episode.css("link").first.content
            title     = episode.css("title").first.content

            episode = Episode.first({:episode => epnum, :season => seasonnum, :product_number => prodnum, :tvr_show_id => show.tvr_show_id})

            if force || !episode
              episode = Episode.new if !episode
              episode.episode        = epnum
              episode.season         = seasonnum
              episode.product_number = prodnum
              episode.url            = link
              episode.air_date       = airdate
              episode.title          = title
              episode.tvr_show_id    = show.tvr_show_id
              show.episodes << episode

              if episode.save
                #puts "new episode saved #{episode.id}"
              else
                #puts "Failed to saved #{episode.errors.inspect}"
              end
            end
          end
        end
      end
    end
  end
end

