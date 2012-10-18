class FlightsearchController < ApplicationController
  DATE_FORMAT = '%d/%m/%Y'
  
  respond_to :json
  
  def index
    booker_params = { id: 'weathersick', type: 12, url: 'http://www.weathersick.com' }
    booker = Flight::VayamaSearch.new(nil, booker_params)
    foo = (DateTime.now.next_week.next_day(5)).to_date.strftime(DATE_FORMAT)
    
    begin
      date_from = DateTime.strptime(params[:date_from], DATE_FORMAT)
    rescue Exception => exc
      date_from = DateTime.strptime(foo, DATE_FORMAT)
    end
    from = params[:from] || 'OSL'
    to = params[:to] || 'LHR'
    adults = params[:adults] || 1
        
    destination = Hash.new
    
    results = booker.search(Flight::VayamaSearch::SEARCH_OW, from, to, date_from, adults)
    
    unless(results.empty?)
      destination[:total_fare] = results[0][:total_fare]
      destination[:booking_link] = results[0][:booking_link]
      destination
    else
      destination[:error] = true
    end

    respond_with destination
    
  end
end
