module Flight
  class Search

    attr_reader :api_url

    def initialize(api_url)
      @api_url = api_url 
    end
  end
end


