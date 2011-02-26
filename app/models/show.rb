class Show
  include DataMapper::Resource

  has n, :episodes

  property :id,          Serial
  property :tvr_show_id, String, :required => true, :unique => true
  property :name,        String, :length => 255
  property :url,         Text
  property :show_status, String, :length => 255
  property :genres,      String, :length => 255
  property :search_as,   String, :length => 255
  timestamps :at

  before :create, :fill_in_my_show_information
  after :create, :get_episodes

  def fill_in_show_information
    show = Show.get_show_xml(self.tvr_show_id)
    Show.populate_show_info(self, show) if show
  end

  def get_episodes
    Episode.import_episodes(false, self.tvr_show_id)
  end

  def fill_in_my_show_information
    Show.fill_in_show_information(self)
  end

  class << self
    def fill_in_show_information(tvr_show_id = nil)
      if tvr_show_id
        shows = tvr_show_id.is_a?(Show) ? [tvr_show_id] : Show.all(:tvr_show_id => tvr_show_id)
      else
        shows = Show.all
      end

      shows.each do |this_show|
        if (show = get_show_xml(this_show.tvr_show_id))
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
          tvr_shows << {
            :name        => tvr_show.at_css("name").content,
            :url         => tvr_show.at_css("link").content,
            :tvr_show_id => tvr_show.at_css("showid").content,
          }
        end
      end

      tvr_shows
    end

    def get_show_xml(tvr_show_id)
      if (doc = Nokogiri::XML(open("http://services.tvrage.com/feeds/showinfo.php?sid=#{tvr_show_id}")))
        show = doc.at_css('Showinfo')
        return show if show
      end
      nil
    end

    def populate_show_info(show, show_info)
      show.name = show_info.at_css("showname").content
      show.url  = show_info.at_css("showlink").content
      show.show_status = show_info.at_css("status").content
      show.genres = show_info.at_css("genres").css("genre").map{|g| g.content }.join(", ")
    end
  end
end

