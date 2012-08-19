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
    id = IntField()
    ident = StringField(max_length=10)
    name = StringField(max_length=300)
    type = StringField(max_length=20)
    latitude = StringField(max_length=50)
    longitude = StringField(max_length=50)
    elevation = IntField()
    continent = StringField(max_length=2)
    iso_country = StringField(max_length=2)
    iso_region = StringField(max_length=5)
    municipality = StringField(max_length=100)
    scheduled_service = StringField(max_length=3)
    local_code = StringField(max_length=30)
    icao = StringField(max_length=4)
    iata = StringField(max_length=3)
    home_link = URLField()
    wikipedia_link = URLField()
    
    # gps_code = ICAO

