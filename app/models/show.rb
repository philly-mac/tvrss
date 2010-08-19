class Show
  include DataMapper::Resource

  has n, :episodes

  property :id,          Serial
  property :tvr_show_id, String
  property :name,        String
  property :url,         Text
  property :show_status, String
  timestamps :at

  before :save, :fill_in_show_information
  after :save, :get_episodes

  def fill_in_show_information
    show = Show.get_show_xml(self.tvr_show_id)
    Show.populate_show_info(self, show) if show
  end

  def get_episodes
    Episode.import_episodes(false, self.tvr_show_id)
  end

  class << self
    def fill_in_show_information
      Show.all.each do |this_show|
        show = get_show_xml(this_show.tvr_show_id)
        if show
          populate_show_info(this_show, show)
          this_show.save
        end
      end
    end

    def get_show_list(search_term)
      tvr_shows = []
      if (doc = Nokogiri::XML(open("http://services.tvrage.com/feeds/search.php?show=#{CGI.escape(search_term)}")))
        results = doc.css('Results').first
        results.css('show').each do |tvr_show|
          Padrino.logger.info "TVR SHOW #{tvr_show}"
          tvr_shows << {
            :name        => tvr_show.css("name").first.content,
            :tvr_show_id => tvr_show.css("showid").first.content,
          }
        end
      end

      tvr_shows
    end

    def get_show_xml(tvr_show_id)
      if (doc = Nokogiri::XML(open("http://services.tvrage.com/feeds/showinfo.php?sid=#{tvr_show_id}")))
        show = doc.css('Showinfo').first
        return show if show
      end

      nil
    end

    def populate_show_info(show, show_info)
      show.name = show_info.css("showname").first.content
      show.url  = show_info.css("showlink").first.content
    end
  end
end

