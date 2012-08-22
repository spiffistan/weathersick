# Create your views here.

from django.views.generic import TemplateView
from django.middleware.csrf import get_token

from web.models import Airport

class IndexView(TemplateView):
    template_name = 'index.html'
    
    def get_context_data(self, **kwargs):
        context = super(IndexView, self).get_context_data(**kwargs)
        context['foo'] = Airport.objects.get(id=1)
        return context

class AjaxTestView(TemplateView):
    template_name = 'ajax.html'