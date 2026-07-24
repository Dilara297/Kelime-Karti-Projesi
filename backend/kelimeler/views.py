from django.shortcuts import render, get_object_or_404, redirect
from .models import List, Word
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import WordSerializer
from datetime import timedelta
from django.utils import timezone
from django.contrib.auth.decorators import login_required
from .forms import KayitFormu
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required,user_passes_test
from django.db.models import Q
from django.contrib.auth.models import User



def liste_gorunumu(request):
    if request.user.is_authenticated:
        listeler = List.objects.filter(Q(owner__isnull=True) | Q(owner=request.user))
    else:
        listeler = List.objects.filter(owner__isnull=True)
    return render(request, 'listeler.html', {'listeler': listeler})

def kelime_gorunumu(request, liste_id):
    liste = get_object_or_404(List, id=liste_id)
    kelimeler = Word.objects.filter(liste=liste)
    duzenleme_yetkisi = False
    if request.user.is_authenticated:
        if liste.owner is None or liste.owner == request.user:
            duzenleme_yetkisi = True
    return render(
        request,
        'kelimeler.html',
        {
            'liste': liste,
            'kelimeler': kelimeler,
            'duzenleme_yetkisi':duzenleme_yetkisi
        }
     )

# --- FLUTTER API ENDPOINTLERİ ---

@api_view(['GET'])
def api_kelime_listesi(request):
    kelimeler = Word.objects.all()
    serializer = WordSerializer(kelimeler, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def kelime_durumu_guncelle(request, kelime_id):
    kelime = get_object_or_404(Word, id=kelime_id)
    
    durum = request.data.get('known') 

    if durum is not None:
        kelime.known = durum

    if durum is True:
        # Doğru bildiyse seviyeyi 1 artır
        kelime.level += 1
    
        # Seviyeye göre kaç gün sonra tekrar sorulacağını hesapla
        gun_farki = 0
        if kelime.level == 1:
            gun_farki = 1  
        elif kelime.level == 2:
            gun_farki = 3 
        elif kelime.level == 3:
            gun_farki = 7  
        elif kelime.level == 4:
            gun_farki = 14 
        else:
            gun_farki = 30 
            
        # Şu anki zamana hesaplanan gün farkını ekle ve yeni tekrar tarihi olarak belirle
        kelime.next_review_date = timezone.now() + timedelta(days=gun_farki)

    elif durum is False:
        # Bilemediyse cezalandır: Seviye sıfırlanır
        kelime.level = 0
        
        # Tekrar tarihi "şu an" yapılır ki desteye çalışmaya devam ederken hemen karşısına çıksın
        kelime.next_review_date = timezone.now()

    kelime.save()
    
    return Response({
        'success': True, 
        'known': kelime.known,
        'level': kelime.level,
        'next_review_date': kelime.next_review_date
    })

@api_view(['POST'])
def api_kelime_ekle(request):
    liste_id = request.data.get('liste_id')
    liste = get_object_or_404(List, id=liste_id)
    
    if liste.owner is not None and liste.owner != request.user:
        return Response({'success': False, 'hata': 'Bu listeye kelime ekleme yetkiniz yok'}, status=403)
    
    yeni_kelime = Word.objects.create(
        liste=liste,
        eng=request.data.get('eng'),
        tr=request.data.get('tr'),
        example=request.data.get('example'),
        known=None 
    )
    return Response({'success': True, 'id': yeni_kelime.id})

@api_view(['POST'])
def api_kelime_sil(request, kelime_id):
    kelime = get_object_or_404(Word, id=kelime_id)
    if kelime.liste.owner is not None and kelime.liste.owner != request.user:
        return Response({'success': False, 'hata': 'Bu kelimeyi silme yetkiniz yok'}, status=403)
    kelime.delete()
    return Response({'success': True})

@api_view(['POST'])
def api_kelime_duzenle(request, kelime_id):
    kelime = get_object_or_404(Word, id=kelime_id)
    if kelime.liste.owner is not None and kelime.liste.owner != request.user:
        return Response({'success': False, 'hata': 'Bu kelimeyi düzenleme yetkiniz yok'}, status=403)
    kelime.eng = request.data.get('eng', kelime.eng)
    kelime.tr = request.data.get('tr', kelime.tr)
    kelime.example = request.data.get('example', kelime.example)
    kelime.save()
    return Response({'success': True})

@api_view(['POST'])
def api_liste_ekle(request):
    liste_adi = request.data.get('isim')
    yeni_liste = List.objects.create(name=liste_adi, owner=request.user)
    return Response({'success': True, 'id': yeni_liste.id, 'isim': yeni_liste.name})

@api_view(['GET'])
def api_listeleri_getir(request):
    tum_listeler = List.objects.all()
    
    # Serializer kullanmak yerine burada manuel JSON formatına çevirdim (Flutter tarafı liste bekliyor)
    data = []
    for liste in tum_listeler:
        data.append({
            'id': liste.id,
            'isim': liste.name
        })
    return Response(data)

@api_view(['POST'])
def api_liste_sil(request, liste_id):
    liste = get_object_or_404(List, id=liste_id)
    if liste.owner is not None and liste.owner != request.user:
        return Response({'success': False, 'hata': 'Bu listeyi silme yetkiniz yok'}, status=403)
    liste.delete()
    return Response({'success': True})

@api_view(['POST'])
def api_liste_duzenle(request, liste_id):
    liste = get_object_or_404(List, id=liste_id)
    if liste.owner is not None and liste.owner != request.user:
        return Response({'success': False, 'hata': 'Bu listeyi düzenleme yetkiniz yok'}, status=403)
    liste.name = request.data.get('isim', liste.name)
    liste.save()
    return Response({'success': True})


@user_passes_test(lambda u: u.is_staff, login_url='ana_sayfa')
def admin_dashboard(request):
    context = {
        'toplam_liste': List.objects.count(),
        'toplam_kelime': Word.objects.count(),
        'toplam_kullanici': User.objects.count(),
    }
    return render(request, 'admin_paneli/admin_dashboard.html', context)

@user_passes_test(lambda u: u.is_staff, login_url='ana_sayfa')
def admin_liste_yonetimi(request):
    listeler = List.objects.all()
    return render(request, 'admin_paneli/liste_yonetimi.html', {'listeler': listeler})


@user_passes_test(lambda u: u.is_staff, login_url='ana_sayfa')
def admin_kelime_yonetimi(request, liste_id):
    liste = get_object_or_404(List, id=liste_id)
    kelimeler = Word.objects.filter(liste=liste)
    return render(request, 'admin_paneli/kelime_yonetimi.html', {
        'liste': liste,
        'kelimeler': kelimeler
    }
    )
    
@user_passes_test(lambda u: u.is_staff, login_url='ana_sayfa')
def admin_kullanicilar(request):
    kullanicilar = User.objects.all()
    return render(request, 'admin_paneli/kullanicilar.html', {'kullanicilar': kullanicilar})


def ana_sayfa(request):
    return render(request, 'ana_sayfa.html')

def kayit_ol(request):
    if request.method == 'POST':
        form = KayitFormu(request.POST)
        if form.is_valid():
            yeni_kullanici = form.save()
            login(request, yeni_kullanici)   
            return redirect('ana_sayfa')
    else:
        form = KayitFormu()
    return render(request, 'kayit_ol.html', {'form': form})

@login_required
def profil_sayfasi(request):
    return render(request, 'profil.html')

def quiz_baslat(request, liste_id):
    liste = get_object_or_404(List, id=liste_id)
    kelimeler = Word.objects.filter(liste=liste)
    return render(request, 'quiz.html', {
        'liste': liste,
        'kelimeler': kelimeler
    })