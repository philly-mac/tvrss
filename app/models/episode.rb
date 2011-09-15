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

  class << self
    def pad_num(num)
      ret = '00'
      s = /(\d+)/.match(num)
      if s
        s = s[0].to_i
        s = "0#{s}" if s.to_s.size == 1
        ret = s
      end
      ret
    end

    def import_episodes(force = false, tvr_show_id = nil)
      requests = []

      shows = tvr_show_id ? Show.all(:tvr_show_id => tvr_show_id) : Show.all

      hydra = Typhoeus::Hydra.new

      # Set up the requests
      Rails.logger.info "Setting up requests"
      shows.each do |show|
        requests << Typhoeus::Request.new("http://services.tvrage.com/feeds/episode_list.php?sid=#{show.tvr_show_id}", {:timeout => 600000})
        requests.last.on_complete do |response|
          [show, Nokogiri::XML(response.body)]
        end
      end

      # Queue each of the reuests
      Rails.logger.info "Queuing up requests"
      requests.each{|requests| hydra.queue requests}

      # Run them
      Rails.logger.info "Running up requests"
      hydra.run

      requests.each do|request|
        show, xml_document = request.handled_response

        xml_document.css('Show Episodelist Season').each do |season|
          season.css("episode").each do |episode|
            epnum     = episode.at_css("epnum").content
            season_no = season['no']
            seasonnum = episode.at_css("seasonnum").content
            prodnum   = episode.at_css("prodnum").content
            airdate   = Date.parse(episode.at_css("airdate").content) rescue nil
            link      = episode.at_css("link").content
            title     = episode.at_css("title").content

            episode = Episode.first(:season => season_no, :episode => epnum, :tvr_show_id => show.tvr_show_id)

            if force || !episode
              episode = Episode.new if !episode
              episode.season         = season_no
              episode.episode        = epnum
              episode.season_episode = seasonnum
              episode.product_number = prodnum
              episode.url            = link
              episode.air_date       = airdate
              episode.title          = title
              episode.tvr_show_id    = show.tvr_show_id
              show.episodes << episode

              if episode.save
                Rails.logger.info "new episode saved #{episode.id}"
              else
                Rails.logger.error "Failed to saved #{episode.errors.inspect}"
              end
            end
          end
        end
      end
    end
  end
end

