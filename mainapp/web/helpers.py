import csv

def import_airports_from_ourairports(file=airports.csv):
    """
    Helper function to import data from http://www.ourairports.com/data.
    
    Data order:
        "id","ident","type","name","latitude_deg","longitude_deg","elevation_ft","continent","iso_country","iso_region","municipality","scheduled_service","gps_code","iata_code","local_code","home_link","wikipedia_link","keywords"
    """
    
    airportReader = csv.reader(open(file, 'rb'))
    
    for row in airportReader
    
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
    icao = models.CharField(max_length=4,null=True,blank=True)
    iata = models.CharField(max_length=3)
    name = models.CharField(max_length=300)