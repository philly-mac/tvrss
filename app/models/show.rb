class Show < Sequel::Model
  include DataMapper::Resource

  # Associations

  many_to_many :users
  one_to_many  :episodes

  before :create do
    fill_in_my_show_information unless independent?
  end

  after  :create do
    get_episodes unless independent?
  end


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

      if xml = show_xml("http://services.tvrage.com/feeds/search.php", { :params => {:show => "#{CGI.escape(search_term)}" }})
        if (doc = Nokogiri::XML(xml))
          results = doc.css('Results').first
          results.css('show').each do |tvr_show|
            tvr_shows << {
              :name        => tvr_show.at_css("name").content,
              :url         => tvr_show.at_css("link").content,
              :tvr_show_id => tvr_show.at_css("showid").content,
            }
          end
        end
      else
        alert = "The was a problem getting the xml"
      end

      tvr_shows
    end

    def get_show_xml(tvr_show_id)
      xml = show_xml("http://services.tvrage.com/feeds/showinfo.php", { :params => {:sid => "#{tvr_show_id}" }})
      if xml && (doc = Nokogiri::XML(xml))
        show = doc.at_css('Showinfo')
        return show if show
      else
        nil
      end
    end

    def show_mappings
      [[:name,'showname'],[:url, 'showlink'], [:show_status, 'status']]
    end

    def populate_show_info(show, show_info)
      show_mappings.each do |fields|
        field = show_info.at_css(fields.last)
        show.send :"#{fields.first}=", field.content if field
      end
      if genres = show_info.at_css("genres")
        if genre = genres.css("genre")
          show.genres = genre.map{|g| g.content }.join(", ")
        end
      end
    end

    def cancelled
      Show.all(:conditions => ['LOWER(show_status) LIKE ?',"%cancelled%"]) |
        Show.all(:conditions => ['LOWER(show_status) LIKE ?',"%ended%"]) |
        Show.all(:conditions => ['LOWER(show_status) LIKE ?',"%canceled%"])
    end

  private

    def show_xml(url, params = {})
      response = Typhoeus::Request.get(url, params)
      return response.success? ? response.body : nil
    end
  end
end

