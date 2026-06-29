# Kelime Kartı - Backend & API (Django)

Bu modül, kelime öğrenme uygulamasının veritabanı yönetimini, aralıklı tekrar algoritmasını ve mobil istemci (Flutter) ile haberleşmesini sağlayan RESTful API sistemidir.

## Öne Çıkan Özellikler ve Algoritma

- **Aralıklı Tekrar (Spaced Repetition) Algoritması:** Backend tarafında her kelime modeline bir `level` (seviye) ve `next_review_date` (bir sonraki gösterim tarihi) alanı atanmıştır. Quiz esnasındaki başarı durumuna göre kelimenin seviyesi artırılarak bir sonraki gösterim tarihi katlanarak ileriye ötelenir; yanlış bilindiğinde ise süreç sıfırlanır.
- **Veri Modellemesi:** `List` (Liste) ve `Word` (Kelime) modelleri arasında One-to-Many ilişkisi kurulmuş, `on_delete=CASCADE` yapısı ile veri bütünlüğü güvenceye alınmıştır.
- **Dinamik JSON Çıktısı:** Mobil uygulamanın verileri hızlıca işleyebilmesi için Django REST Framework (DRF) serializers yapıları kullanılmıştır.

## Temel API Uç Noktaları (Endpoints)

- `GET /api/listeler/` - Tüm kelime listelerini ve istatistikleri getirir.
- `GET /api/kelimeler/` - Filtrelenmiş veya tüm kelime listesini JSON olarak döner.
- `POST /api/kelime/ekle/` - Veritabanına yeni bir kelime kaydeder.
- `POST /api/kelime/{id}/guncelle/` - Kelimenin seviyesini ve bir sonraki gösterim tarihini günceller.
- `POST /api/kelime/{id}/sil/` - Belirtilen kelimeyi veritabanından siler.
