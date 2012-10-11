module Weather
  class Search

    attr_reader :api_url, :api_key

    def initialize(api_url, api_key)
      @api_url = api_url 
      @api_key = api_key
    end
  end
end


