class Xml

  def self.fetch(url, params = {})
    response = Typhoeus::Request.get(url, params)
    return response.success? ? response.body : nil
  end
end
