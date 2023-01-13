from django.urls import path
from .views import main, user_login


urlpatterns = [
  path('', main, name='main'),
  path('login', user_login, name='login')
]