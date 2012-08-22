# Create your views here.

from django.views.generic import TemplateView
from django.utils import simplejson
from django.views.decorators.csrf import ensure_csrf_cookie, csrf_exempt

from dajaxice.decorators import dajaxice_register
from mongoengine import *

from web.models import Airport

def get_count(request):
    count = Airport.objects.count()
    return count

def load_airport(request, num):
    airports = Airport.objects.filter(type='large_airport')
    airport = airports[num]
    
    return simplejson.dumps({
        'name':airport.name, 
        'latitude':airport.latitude_deg, 
        'longitude':airport.longitude_deg,
        'iata_code':airport.iata_code,
        'wikipedia_link':airport.wikipedia_link,
    })

get_count = dajaxice_register(get_count)[0]
load_airport = dajaxice_register(load_airport)[0]