class SearchController < ApplicationController

  DATE_FORMAT = '%v'
  
  respond_to :json

  def flights

    # TODO: error checking
    # TODO: singleton this object
    booker_params = { id: 'commj', type: 12, url: 'http://www.weathersick.com' }
    booker = Flight::VayamaSearch.new(nil, booker_params)
    
    date_from = DateTime.strptime(params[:date_from], DATE_FORMAT) || DateTime.now.next_week.next_day(3)
    date_to = DateTime.strptime(params[:date_to], DATE_FORMAT) || DateTime.now.next_week.next_day(7)

    from = params[:from] || 'OSL'
    to = params[:to] || 'LHR'

    adults = params[:adults] || 1
    children = params[:children] || 0

    limit = params[:limit] || 16
    type = params[:type] || 1 # 1 = OW, 2 = RT

    # TODO: require the types?
    case type
    when 1
      results = booker.search(Flight::VayamaSearch::SEARCH_OW, from, to, adults, children, date_from, date_to, limit)
    when 2
      results = booker.search(Flight::VayamaSearch::SEARCH_RT, from, to, adults, children, date_from, date_to, limit)
    end

    logger.debug results
    respond_with results
    
  end
end
