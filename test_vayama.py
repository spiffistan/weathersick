import datetime
import time
import requests
from bs4 import BeautifulSoup, Tag
from lxml import etree

URL = 'http://www.Vayama.com/axis2/services/VayamaService'

class FlightSearch(object):
    pass

class VayamaSearch(FlightSearch):
    """
    Class to search for trips on Vayama's API.
    
    Only named arguments are used to initiate this class. They are:
    trip: One of the choices in valid_trips
    origin: Three-letter IATA airport code
    destination: Ditto
    origin_departure_time: datetime.datetime object for departure, origin
    destination_departure_time: datetime.datetime object for departure, return trip
    adults: Number of adults on the trip. It will be casted to a string, so don't worry if it's not.
    children: ditto
    cabin: Selection of cabin. Economy is the only one implemented.
    """
    valid_trips = ['roundtrip', 'oneway', 'openjaw']
    
    def __init__(self, 
                trip='roundtrip', 
                origin='EWR', 
                destination='ATL', 
                origin_departure_time=(datetime.datetime.now() + datetime.timedelta(7)),
                destination_departure_time=(datetime.datetime.now() + datetime.timedelta(14)),
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
                
        self.construct_xml()

    def construct_xml(self):
        soup = BeautifulSoup(etree.tostring(etree.Element('OTA_AirLowFareSearchRQ')), 'xml')
        query = soup.contents[0]
        query.attrs = {
            'xmlns':'http://www.opentravel.org/OTA/2003/05',
            'xmlns:xsi':'http://www.w3.org/2001/XMLSchema-instance',
            'PrimaryLangId':'en',
            'Version':'2.001',
            'TimeStamp':str(datetime.datetime.now().isoformat()),
            'EchoToken':str(time.mktime(time.gmtime())),
            'xsi:schemaLocation':'http://www.opentravel.org/2006A/OTA_AirLowFareSearchRQ.xsd',
        }
        
        t_pos = Tag(name='POS')
        t_source = Tag(name='Source')
        t_req = Tag(name='RequestorID')
        t_req.attrs = {
            'ID':'weathersick',
            'URL':'http://www.weathersick.com',
            'Type':'18',
        }
        t_source.append(t_req)
        t_pos.append(t_source)
        query.append(t_pos)
        
        t_odinf = Tag(name='OriginDestinationInformation')
        t_odinf.attrs {'RPH':1}
        t_deptime = Tag(name='DepartureDateTime')
        t_deptime.
        
        OriginDestinationInformation RPH="1"
        
        import pdb; pdb.set_trace()
        

    def dispatch(self):
        xml = self.construct_xml()
        url = URL
        headers = {'content-type': 'text/xml'}
        r = requests.post(URL, data=xml, headers=headers)
        return r