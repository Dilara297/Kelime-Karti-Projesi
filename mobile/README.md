# Kelime Kartı - Mobil Uygulama (Flutter)

Bu modül, kelime öğrenme uygulamasının kullanıcı arayüzünü barındırır. Uygulama, backend'de çalışan REST API ile haberleşerek verileri çeker ve yönetir.

## Öne Çıkan Özellikler

- **Çift Çalışma Modu:** Tüm desteyi sırayla çalışabileceğiniz "Serbest Mod" ve yalnızca vakti gelen kelimeleri karşınıza çıkaran "Aralıklı Tekrar" (Spaced Repetition) modu.
- **İlerleme Takibi:** Liste ekranında destedeki genel öğrenme oranını gösteren istatistikler.
- **Etkileşimli Kartlar:** Quiz ekranında dokunarak İngilizce/Türkçe arası geçiş yapılabilen Flashcard yapısı.
- **Kelime Yönetimi:** Yeni kelime ekleme, düzenleme ve "biliyorum/bilmiyorum" olarak işaretleme.

## Notlar

- Uygulama şu an yerel ağda çalışmaktadır
- Django sunucusu ve telefon aynı WiFi ağında olmalıdır
- `api_service.dart` içindeki IP adresini kendi ağınıza göre güncellemeniz gerekir

