class Show < Sequel::Model

  many_to_many :users
  one_to_many  :episodes

  def self.populate_fields(shows)
    shows.each do |show|
      if (xml = self.xml(show.tvr_show_id))
        show.read_in_xml(xml)
      end
    end
  end

  def self.search_db(search_term)
    Show.where(Sequel.ilike(:name, "%#{search_term}%")).all
  end

  def self.search_tv_rage(search_term)
    shows = []

    if xml = Xml.fetch("http://services.tvrage.com/feeds/search.php", { :params => {:show => "#{CGI.escape(search_term)}" }})
      if doc = Nokogiri::XML(xml)
        results = doc.css('Results').first
        results.css('show').each do |show_xml|
          shows << {
            :name    => show_xml.at_css("name").content,
            :url     => show_xml.at_css("link").content,
            :tvr_id  => show_xml.at_css("showid").content,
          }
        end
      end
    end

    shows
  end

  def self.xml(tvr_id)
    xml = Xml.fetch("http://services.tvrage.com/feeds/showinfo.php", { :params => {:sid => "#{tvr_id}" }})
    if xml && (doc = Nokogiri::XML(xml))
      doc.at_css('Showinfo')
    end
  end

  def self.mappings
    [[:name,'showname'],[:url, 'showlink'], [:show_status, 'status']]
  end

  def self.cancelled
    Show.where(Sequel.ilike(:show_status, ["%cancelled%","%ended%","%canceled%"])).all
  end

  def fetch_episodes
    Episode.import([self])
  end

  def read_in_xml(xml)
    Show.mappings.each do |fields|
      field = xml.at_css(fields.last)
      self.send :"#{fields.first}=", field.content if field
    end

    if genres = xml.at_css("genres")
      if genre = genres.css("genre")
        self.genres = genre.map{|g| g.content }.join(", ")
      end
    end
  end

private

  def before_create
    Show.populate_fields([self])
    super
  end

  def after_create
    fetch_episodes
    super
  end

end

