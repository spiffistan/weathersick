import datetime
import time
import requests
from bs4 import BeautifulSoup
from lxml import etree

URL = 'http://www.Vayama.com/axis2/services/VayamaService'

class Booking(object):
    pass

class VayamaBooking(Booking):
    valid_trips = ['roundtrip', 'oneway', 'openjaw']
    
    def __init__(self, 
                trip='roundtrip', 
                origin='EWR', 
                destination='ATL', 
                origin_departure_time=(datetime.datetime.now() + datetime.timedelta(7)).isoformat(),
                destination_departure_time=(datetime.datetime.now() + datetime.timedelta(14)).isoformat(),
                adults='1', 
                children='0',
                cabin='Economy'):
                
                if trip not in self.valid_trips:
                    if trip == 'openjaw':
                        raise NotImplementedError("Open Jaw trips are not yet implemented.")
                    raise ValueError("Not a valid trip type. Choose either 'roundtrip', 'oneway' or 'openjaw'.")
                if len(origin.upper()) != 3 or len(destination) != 3:
                    raise ValueError("Origin or destination is not a valid airport. Use three letters and a valid IATA airport code.")
                if type(origin_departure_time) != datetime.datetime or type(destination_departure_time) != datetime.datetime:
                    raise ValueError('Please use valid datetime.datetime instances for departure times.')
                if trip != 'oneway':
                    if origin_departure_time > destination_departure_time:
                        raise ValueError("You can't leave before you go.")
                
                adults = str(adults)
                children = str(children)
                if len(adults) != 1 or len(children) != 1:
                    raise ValueError("Jesus, how many people are you taking with you? Or something else might be wrong. Anyway, check your values for adults and children.")
                
                if cabin != 'Economy':
                    raise NotImplementedError('Snob.')
                
                self.trip = trip
                self.origin = origin
                self.destination = destination
                self.origin_departure_time = origin_departure_time
                self.destination_departure_time = destination_departure_time
                self.adults = adults
                self.children = children
                self.cabin = cabin
    
        def construct_xml()
            soup = BeautifulSoup(etree.tostring(etree.Element('OTA_AirLowFareSearchRQ')), 'xml')
            
        
        xml = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <OTA_AirLowFareSearchRQ xmlns="http://www.opentravel.org/OTA/2003/05" PrimaryLangID="en" Version="2.001"
        TimeStamp="%s" EchoToken="%s">
        <POS>
        <Source>
        <RequestorID ID="weathersick" Type="18" URL="http://www.weathersick.com"/>
        </Source>
        </POS>
        <OriginDestinationInformation RPH="1">
        <DepartureDateTime>%s</DepartureDateTime>
        <OriginLocation MultiAirportCityInd="false" CodeContext="IATA" LocationCode="%s"/>
        <DestinationLocation MultiAirportCityInd="false" CodeContext="IATA" LocationCode="%s"/>
        </OriginDestinationInformation>
        <OriginDestinationInformation RPH="1">
        <DepartureDateTime>%s</DepartureDateTime>
        <OriginLocation MultiAirportCityInd="false" CodeContext="IATA" LocationCode="%s"/>
        <DestinationLocation MultiAirportCityInd="false" CodeContext="IATA" LocationCode="%s"/>
        </OriginDestinationInformation>
        <TravelPreferences>
        <FlightTypePref PreferLevel="Preferred" MaxConnections="3" FlightType="Connection"/>
        <CabinPref PreferLevel="Preferred" Cabin="%s"/>
        </TravelPreferences>
        <TravelerInfoSummary TicketingCountryCode="US">
        <AirTravelerAvail>
        <PassengerTypeQuantity Quantity="%d" Code="%s"/>
        <PassengerTypeQuantity Quantity="%d" Code="%s"/>
        </AirTravelerAvail>
        </TravelerInfoSummary>
        </OTA_AirLowFareSearchRQ>""" % (datetime.datetime.now().isoformat(),
            time.mktime(datetime.datetime.now().timetuple()),
            self.departure_times[0].isoformat(), 
            self.origin, 
            self.destination, 
            self.departure_times[1].isoformat(), 
            self.destination, 
            self.origin, 
            self.cabin, 
            self.passengers[0][1], 
            self.passengers[0][0], 
            self.passengers[1][1], 
            self.passengers[1][0])
        return xml

    def dispatch(self):
        xml = self.construct_xml()
        url = URL
        headers = {'content-type': 'text/xml'}
        r = requests.post(URL, data=xml, headers=headers)
        return r