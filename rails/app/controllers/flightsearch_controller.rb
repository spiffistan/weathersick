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
    children = params[:children] || 0
    limit = params[:limit] || 5
        
    destination = Hash.new
    destination[:success] = true
    destination[:results] = []
    i = 0
    
    results = booker.search(Flight::VayamaSearch::SEARCH_OW, from, to, date_from, adults, children)

    unless(results.empty?)
      results.each do |result|
        destination[:results][i] = Hash.new
        destination[:results][i][:total_fare] = results[i][:total_fare]
        destination[:results][i][:booking_link] = results[i][:booking_link]
        i += 1
        if i == limit
          break
        end
      end
    else
      destination[:success] = false
    end

    respond_with destination
    
  end
end
