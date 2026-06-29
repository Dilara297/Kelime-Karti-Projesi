import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/kelime.dart';

// Django backend'in çalıştığı adres
// gerçek cihazda test ederken bu ip değişebilir
const String baseUrl = 'http://192.168.1.108:8000';

Future<List<Kelime>> kelimeleriGetir() async {
  var url = Uri.parse('$baseUrl/api/kelimeler/');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> veriListesi = jsonDecode(utf8.decode(response.bodyBytes));
    // Uzun for döngüsü yerine doğrudan factory kullanarak listeye çeviriyoruz:
    return veriListesi.map((json) => Kelime.fromJson(json)).toList();
  } else {
    throw Exception(
      'Kelimeler gelirken bir sorun oldu: ${response.statusCode}',
    );
  }
}

// kelimenin öğrenildi mi öğrenilmedi mi durumunu güncelliyoruz
Future<void> kelimeDurumuGuncelle(int id, bool yeniDurum) async {
  final url = Uri.parse('$baseUrl/api/kelime/$id/guncelle/');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'known': yeniDurum}),
    );

    if (response.statusCode != 200) {
      print('güncelleme olmadı, kod: ${response.statusCode}');
    }
  } catch (e) {
    print('sunucuya bağlanılamadı: $e');
  }
}

// yeni kelime ekleme
Future<bool> kelimeEkle(
  int listeId,
  String eng,
  String tr,
  String ornek,
) async {
  final url = Uri.parse('$baseUrl/api/kelime/ekle/');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'liste_id': listeId,
        'eng': eng,
        'tr': tr,
        'example': ornek,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('kelime eklenemedi: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('hata: $e');
    return false;
  }
}

// kelime silme
Future<bool> kelimeSil(int kelimeId) async {
  final url = Uri.parse('$baseUrl/api/kelime/$kelimeId/sil/');

  try {
    final response = await http.post(url);
    return response.statusCode == 200;
  } catch (e) {
    print('silme hatası: $e');
    return false;
  }
}

// kelime düzenleme
Future<bool> kelimeDuzenle(
  int kelimeId,
  String eng,
  String tr,
  String ornek,
) async {
  final url = Uri.parse('$baseUrl/api/kelime/$kelimeId/duzenle/');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'eng': eng, 'tr': tr, 'example': ornek}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print('düzenleme hatası: $e');
    return false;
  }
}

// yeni liste oluşturma
Future<bool> listeEkle(String listeIsmi) async {
  final url = Uri.parse('$baseUrl/api/liste/ekle/');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'isim': listeIsmi}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('liste eklenemedi: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('hata: $e');
    return false;
  }
}

// tüm listeleri çekiyoruz
Future<List<Map<String, dynamic>>> listeleriGetir() async {
  final url = Uri.parse('$baseUrl/api/listeler/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> gelenVeri = jsonDecode(utf8.decode(response.bodyBytes));
      return gelenVeri.cast<Map<String, dynamic>>();
    } else {
      print('listeler çekilemedi: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Listeler getirilirken sunucuya bağlanılamadı: $e');
    return [];
  }
}

// liste silme
Future<bool> listeSil(int listeId) async {
  final url = Uri.parse('$baseUrl/api/liste/$listeId/sil/');
  try {
    final response = await http.post(url);
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

// liste adı güncelleme
Future<bool> listeDuzenle(int listeId, String yeniIsim) async {
  final url = Uri.parse('$baseUrl/api/liste/$listeId/duzenle/');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'isim': yeniIsim}),
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
