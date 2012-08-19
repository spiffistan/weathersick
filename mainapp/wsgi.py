import os
import sys
#
os.environ['DJANGO_SETTINGS_MODULE'] = 'weathersick.settings'
import django.core.handlers.wsgi
djangoapplication = django.core.handlers.wsgi.WSGIHandler()
def application(environ, start_response):
    if 'SCRIPT_NAME' in environ:
        del environ['SCRIPT_NAME']
    return djangoapplication(environ, start_response)
# The following lines enable the werkzeug debugger
import django.views.debug
def null_technical_500_response(request, exc_type, exc_value, tb):
    raise exc_type, exc_value, tb
django.views.debug.technical_500_response = null_technical_500_response
from werkzeug.debug import DebuggedApplication
application = DebuggedApplication(application, evalex=True)
