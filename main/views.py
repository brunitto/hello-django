from django.http import HttpResponse
from django.views import View


class HelloView(View):

    def get(self, request):
        return HttpResponse("<h1>Hello Django</h1>")
