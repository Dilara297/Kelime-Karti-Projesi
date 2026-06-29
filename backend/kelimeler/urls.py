from django.urls import path
from . import views

urlpatterns = [
    path('listeler/', views.liste_gorunumu, name='liste_gorunumu'),
    path('listeler/<int:liste_id>/', views.kelime_gorunumu, name='kelime_gorunumu'),
    path('api/kelimeler/', views.api_kelime_listesi, name='api_kelime_listesi'),
    path('api/kelime/<int:kelime_id>/guncelle/', views.kelime_durumu_guncelle, name='kelime_durumu_guncelle'),
    
    path('api/kelime/ekle/', views.api_kelime_ekle, name='api_kelime_ekle'),
    path('api/kelime/<int:kelime_id>/sil/', views.api_kelime_sil, name='api_kelime_sil'),
    path('api/kelime/<int:kelime_id>/duzenle/', views.api_kelime_duzenle, name='api_kelime_duzenle'),
    path('api/liste/ekle/', views.api_liste_ekle, name='api_liste_ekle'),
    path('api/listeler/', views.api_listeleri_getir, name='api_listeleri_getir'),
    path('api/liste/<int:liste_id>/sil/', views.api_liste_sil, name='api_liste_sil'),
    path('api/liste/<int:liste_id>/duzenle/', views.api_liste_duzenle, name='api_liste_duzenle'),
]
