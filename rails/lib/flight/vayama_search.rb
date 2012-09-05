require 'Nokogiri'
require 'time'
require 'net/http'


# Interface to the Vayama API
class Flight::VayamaSearch < Flight::Search

  API_URL = 'http://www.vayama.com/axis2/services/VayamaService' # Default API URL
  SEARCH_OW = 1, SEARCH_RT = 2, SEARCH_OJ = 3, SEARCH_MC = 4, SEARCH_LB = 5

  attr_reader :requestor_id, :requestor_url, :requestor_type

  def initialize(api_url, params)
    api_url ||= API_URL
    super(api_url) 
    @requestor_url = params[:url] 
    @requestor_id = params[:id] 
    @requestor_type = params[:type]
  end

  # Search Vayama for a trip
  def search(type, from, to, time, num_people)
    
    # TODO sanity-check parameters?

    request = build_request({type: type, from: from, to: to, time: time, num_people: num_people})

    response = send_request(request)


    # TODO if response error
    results = process_response(type, response)
    # XXX present results? 
    #
    return results
  end

  # Builds an XML-request to be sent to the API endpoint
  def build_request(params)

    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.OTA_AirLowFareSearchRQ(
        xmlns: 'http://www.opentravel.org/OTA/2003/05',
        PrimaryLangID: 'en',
        Version: '2.001',
        TimeStamp: DateTime.now.iso8601(3),
        EchoToken: Time.now.to_i) do 

        xml.POS do
          xml.Source do
            xml.RequestorID(ID: @requestor_id, Type: @requestor_type, URL: @requestor_url) 
          end
        end

        ### Data section ###################################################

        case params[:type]
        when SEARCH_OW # One-way search

          xml.OriginDestinationInformation(RPH: '1') do
            xml.DepartureDateTime params[:time].iso8601(0).split('+')[0]
            xml.OriginLocation(MultiAirportCityInd: 'false', CodeContext: 'IATA', LocationCode: params[:from])
            xml.DestinationLocation(MultiAirportCityInd: 'false', CodeContext: 'IATA', LocationCode: params[:to])
          end

        when SEARCH_RT # Round-trip search
        when SEARCH_OJ # Open-jaw search
        when SEARCH_MC # Multi-city search
        when SEARCH_LB # Location-based search
        end

        # TODO
        xml.TravelPreferences do
          xml.FlightTypePref(PreferLevel: 'Preferred', MaxConnections: '3', FlightType: 'Connection')
          xml.CabinPref(PreferLevel: 'Preferred', Cabin: 'Economy')
        end

        # TODO
        xml.TravelerInfoSummary(TicketingCountryCode: 'US') do
          xml.AirTravelerAvail do
            xml.PassengerTypeQuantity(Quantity: params[:num_people], Code: 'ADT')
          end
        end

      end
    end

    return builder.to_xml
  end

  def send_request(xml)
    uri = URI.parse(@api_url)
    request = Net::HTTP::Post.new(uri.path)
    request.body = xml
    request.content_type = 'text/xml'
    response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request request }

    return response
  end

  def process_response(type, response)
    results = []
    doc = Nokogiri::XML(response.body)
    #puts doc
    doc.remove_namespaces!
    success = doc.xpath('//OTA_AirLowFareSearchRS').first['EchoToken'] == "Error" ? false : true
    
    doc.xpath('//OTA_AirLowFareSearchRS/PricedItineraries/PricedItinerary').each do |elem|

      itinerary = {}

      itinerary[:num_segments] = 0
      itinerary[:segments] = []

      elem.xpath('.//AirItinerary/OriginDestinationOptions/OriginDestinationOption/FlightSegment').each do |elem|
        
        segment = {}

        itinerary[:num_segments] += 1

        segment[:departure_datetime]  = DateTime.parse(elem['DepartureDateTime']) # XXX local time? UTC?
        segment[:arrival_datetime]    = DateTime.parse(elem['ArrivalDateTime']) # XXX local time? UTC?

        elem.children.each do |elem|

          case elem.node_name
          when 'DepartureAirport'
            segment[:departure_code] = elem['LocationCode']
          when 'ArrivalAirport'
            segment[:arrival_code] = elem['LocationCode']
          when 'MarketingAirline'
            segment[:marketing_airline_code] = elem['Code']
          when 'OperatingAirline'
            segment[:operating_airline_code] = elem['Code']
          end

        end

        itinerary[:segments] << segment
      end

      basefare = elem.xpath('.//AirItineraryPricingInfo/ItinTotalFare/BaseFare').first
      dec = basefare['DecimalPlaces'].to_i
      fare = basefare['Amount']
      (1..dec).each { fare.chop! } 
      itinerary[:base_fare] = fare
      
      totalfare = elem.xpath('.//AirItineraryPricingInfo/ItinTotalFare/TotalFare').first
      dec = totalfare['DecimalPlaces'].to_i
      fare = totalfare['Amount']
      (1..dec).each { fare.chop! } 
      itinerary[:total_fare] = fare
      
      link = elem.xpath('.//BookItArgument[@Name="clickableURL"]').first['Value']
      itinerary[:booking_link] = link
      
      results << itinerary
    end
    final = {success:success, results:results}
    return final
  end
end
