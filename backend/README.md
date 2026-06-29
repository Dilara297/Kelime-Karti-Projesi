# Kelime Kartları - Backend & API (Django)

Bu proje, "Kelime kartları" mobil uygulamasının veri tabanı yönetimini ve istemci-sunucu haberleşmesini sağlayan arka uç (backend) sistemidir. İstemci (Flutter) tarafına JSON formatında veri sunan RESTful API uç noktaları içerir.

## Kullanılan Teknolojiler
* **Backend Framework:** Python / Django
* **API Mimarisi:** Django REST Framework (DRF)
* **Veri Tabanı:** SQLite
* **İlişkisel Veri Modelleri:** One-to-Many (Liste ve Kelime ilişkisi)

## API Uç Noktaları (Endpoints)
Mobil uygulamanın kullandığı temel API yolları şunlardır:
* `GET /api/listeler/` - Tüm kelime listelerini getirir.
* `POST /api/liste_ekle/` - Yeni bir liste oluşturur.
* `GET /api/kelimeler/` - Listeye ait kelimeleri JSON olarak döner.
* `POST /api/kelime_ekle/` - Sisteme yeni kelime kaydeder.
* `POST /api/kelime_sil/<id>/` - Belirtilen kelimeyi veri tabanından siler.

## Mimari Notlar
* Veri tabanında `List` ve `Word` olmak üzere iki temel model kullanılmış olup, `on_delete=CASCADE` yapısı ile veri bütünlüğü sağlanmıştır.
* Dışa açık API yapısı oluşturulurken `serializers` köprüleri kullanılmıştır.

---
*Not: Bu uygulamanın mobil arayüz (frontend) kodlarına ve tasarım detaylarına Flutter Depomdan ulaşabilirsiniz.*
