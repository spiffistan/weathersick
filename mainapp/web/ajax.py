# Create your views here.

from django.views.generic import TemplateView
from django.utils import simplejson

from dajaxice.decorators import dajaxice_register
from mongoengine import *

from web.models import Airport

@dajaxice_register
def get_count():
    count = Airport.objects.count()

@dajaxice_register
def load_airport(request, num):
    airports = Airport.objects.filter(in_use=True)
    airport = airports[num]
    
    return simplejson.dumps({
        'name':airport.name, 
        'latitude':airport.latitude, 
        'longitude':airport.longitude,
        'iata_code':airport.iata_code,
        'wikipedia_link':airport.wikipedia_link,
    })