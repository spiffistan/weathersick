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

class Airports(Document):
    _id = IntField()
    continent = StringField()
    elevation = IntField()
    gps_code = StringField()
    home_link = URLField()
    iata_code = StringField()
    ident = StringField()
    iso_country = StringField()
    iso_region = StringField()
    keywords = StringField()
    latitude = FloatField()
    local_code = StringField()
    longitude = FloatField()
    municipality = StringField()
    name = StringField(max_length=300)
    scheduled_service = StringField()
    type = StringField(max_length=20)
    wikipedia_link = StringField()
