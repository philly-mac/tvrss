class Episode
  include DataMapper::Resource

  belongs_to :show

  property :id,             Serial
  property :episode,        String,   :length  => 255
  property :season,         String,   :length  => 255
  property :season_episode, String,   :length  => 255
  property :product_number, String,   :length  => 255
  property :air_date,       Date
  property :url,            Text
  property :title,          String,   :length  => 255
  property :tvr_show_id,    String,   :length  => 255
  property :watched,        Boolean, :default => false
  timestamps :at

  def self.pad_num(num)
    ret = '00'
    s = /(\d+)/.match(num)
    if s
      s = s[0].to_i
      s = "0#{s}" if s.to_s.size == 1
      ret = s
    end
    ret
  end

  def self.populate_episodes(show, xml_document)
    Episode.all(:show_id => shows.map(&:id)).destroy

    xml_document.css('Show Episodelist Season').each do |season|
      season.css("episode").each do |episode|
        epnum     = episode.at_css("epnum").content
        season_no = season['no']
        seasonnum = episode.at_css("seasonnum").content
        prodnum   = episode.at_css("prodnum").content
        airdate   = Date.parse(episode.at_css("airdate").content) rescue nil
        link      = episode.at_css("link").content
        title     = episode.at_css("title").content

        episode = Episode.new({
          :season         => season_no,
          :episode        => epnum,
          :season_episode => seasonnum,
          :product_number => prodnum,
          :url            => link,
          :air_date       => airdate,
          :title          => title,
          :tvr_show_id    => show.tvr_show_id
        })

        show.episodes << episode

        if episode.save
          Rails.logger.info "new episode saved #{episode.id}"
        else
          Rails.logger.error "Failed to saved #{episode.errors.inspect}"
        end
      end
    end
  end

  def self.import_episodes(tvr_show_id = nil)
    counter = 0
    failed_shows = []

    shows = tvr_show_id ? Show.all(:tvr_show_id => tvr_show_id) : Show.all

    shows.each do |show|
      counter = 0

      while counter < 5
        Rails.logger.info "Try #{counter + 1} to get #{show.name}"
        response = Typhoeus::Request.get(Typhoeus::Request.new("http://services.tvrage.com/feeds/episode_list.php?sid=#{show.tvr_show_id}", {:timeout => 600000}))

        if response.success?
          Rails.logger.info "#{show.name} success"
          populate_episodes(show, Nokogiri::XML(response.body))
          break
        else
          Rails.logger.info "HTTP request failed: " + response.code.to_s
          Rails.logger.info "#{show.name} failure.."

          counter += 1

          if counter < 5
            Rails.logger.info "#{show.name} trying again"
          else
            failed_shows << show.name
          end

        end
      end
    end

    failed_shows
  end

end

