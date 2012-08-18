from mongoengine import *

# 
# These models are built with MongoEngine.
# Remember: 
# CharField = StringField
# IntegerField = IntField
# 
# In addition, MongoEngine has the following:
# 
# EmbeddedDocumentField
# DictField
# ListField
# SortedListField
# BinaryField
# ObjectIdField
# FileField
# 

class Airport(Document):
    icao = StringField(max_length=4,null=True,blank=True)
    iata = StringField(max_length=3)
    name = StringField(max_length=300)

class OrbitzAirport(Airport):
    pass

class OpenairAirport(Airport):
    id = models.IntegerField()
    ident = models.CharField(max_length=10)
    type = models.CharField(max_length=20)
    latitude = models.CharField(max_length=50)
    longitude = models.CharField(max_length=50)
    elevation = models.IntegerField()
    continent = models.CharField(max_length=2)
    iso_country = models.CharField(max_length=2)
    iso_region = models.CharField(max_length=5)
    municipality = models.CharField(max_length=100)
    scheduled_service = models.CharField(max_length=3)
    local_code = models.CharField(max_length=30,null=True,blank=True)
    home_link = models.URLField(null=True,blank=True)
    wikipedia_link = models.URLField(null=True,blank=True)
    
    # gps_code = ICAO

