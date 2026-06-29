# Kelime Öğrenme Uygulaması

Ders projesi kapsamında Django ve Flutter kullanarak geliştirdiğim kelime öğrenme uygulaması.

## Proje Hakkında

Bu uygulama, kullanıcıların kelime listeleri oluşturup bu listelere kelime ekleyebildiği, kelimeleri quiz modunda çalışabildiği bir mobil uygulamadır. Django tarafı REST API olarak çalışmakta, Flutter ise bu API'den veri çekerek mobil arayüzü sunmaktadır.

## Özellikler

- Kelime listesi oluşturma, düzenleme ve silme
- Listeye kelime ekleme (İngilizce, Türkçe, örnek cümle)
- Kelimeleri biliyorum / bilmiyorum olarak işaretleme
- Quiz modu: kartlara tıklayarak İngilizce/Türkçe arası geçiş
- Django Admin paneli üzerinden veri yönetimi

## Kullanılan Teknolojiler

**Backend (Django)**
- Python 
- Django 
- Django REST Framework
- SQLite

**Frontend (Flutter)**
- Flutter 
- Dart
- http paketi (API istekleri için)

## Kurulum

### Django Backend

```bash
# Repoyu klonla
git clone https://github.com/kullaniciadi/kelime-ogrenme-uygulamasi.git
cd kelime-ogrenme-uygulamasi

# Sanal ortam oluştur ve aktif et
python -m venv venv
venv\Scripts\activate  # Windows

# Gereksinimleri kur
pip install -r requirements.txt

# Veritabanını oluştur
python manage.py migrate

# Sunucuyu başlat
python manage.py runserver 0.0.0.0:8000
```

### Flutter Frontend

```bash
cd kelime_uygulamasi

# Paketleri indir
flutter pub get

# api_service.dart dosyasındaki baseUrl'i kendi IP adresinle değiştir
# const String baseUrl = 'http://SENIN_IP_ADRESIN:8000';

# Uygulamayı çalıştır
flutter run
```


## API Endpointleri

| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | /api/listeler/ | Tüm listeleri getirir |
| GET | /api/kelimeler/ | Tüm kelimeleri getirir |
| POST | /api/kelime/ekle/ | Yeni kelime ekler |
| POST | /api/kelime/{id}/guncelle/ | Kelime durumunu günceller |
| POST | /api/kelime/{id}/sil/ | Kelimeyi siler |

## Notlar

- Uygulama şu an yerel ağda çalışmaktadır
- Django sunucusu ve telefon aynı WiFi ağında olmalıdır
- `api_service.dart` içindeki IP adresini kendi ağınıza göre güncellemeniz gerekir

