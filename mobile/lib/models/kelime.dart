class Kelime {
  final int id;
  final int list_id;
  final String eng;
  final String tr;
  final String example;
  bool? known;

  final int level;
  final DateTime nextReviewDate;

  Kelime({
    required this.id,
    required this.list_id,
    required this.eng,
    required this.tr,
    required this.example,
    this.known,
    required this.level,
    required this.nextReviewDate,
  });

  // API'den gelen veriyi modelimize dönüştüren fabrikayı kurduk
  factory Kelime.fromJson(Map<String, dynamic> json) {
    return Kelime(
      id: json['id'],
      // Django'daki ForeignKey ismini (liste) burada kendi list_id değişkenimize mapliyoruz
      list_id: json['liste'] ?? 0,
      eng: json['eng'] ?? "Kelime bulunamadı",
      tr: json['tr'] ?? "Anlamı yok",
      example: json['example'] ?? "Örnek cümle eklenmemiş.",
      known: json['known'],
      level: json['level'] ?? 0,
      nextReviewDate: json['next_review_date'] != null
          ? DateTime.parse(json['next_review_date'])
          : DateTime.now(),
    );
  }
}
