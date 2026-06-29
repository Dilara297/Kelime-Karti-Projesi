import 'package:flutter/material.dart';
import 'api_service.dart';

class KelimeEkleSayfasi extends StatefulWidget {
  final int listeId;

  const KelimeEkleSayfasi({super.key, required this.listeId});

  @override
  State<KelimeEkleSayfasi> createState() => _KelimeEkleSayfasiState();
}

class _KelimeEkleSayfasiState extends State<KelimeEkleSayfasi> {
  final engController = TextEditingController();
  final trController = TextEditingController();
  final ornekController = TextEditingController();

  @override
  void dispose() {
    engController.dispose();
    trController.dispose();
    ornekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Yeni Kelime Ekle",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _ozelMetinKutusu(engController, "İngilizce Kelime"),
            const SizedBox(height: 15),
            _ozelMetinKutusu(trController, "Türkçe Anlamı"),
            const SizedBox(height: 15),
            _ozelMetinKutusu(ornekController, "Örnek Cümle"),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade600,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.blueGrey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  String engText = engController.text.trim();
                  String trText = trController.text.trim();
                  String ornekText = ornekController.text.trim();

                  if (engText.isEmpty || trText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Kelime ve anlamı boş bırakılamaz!"),
                      ),
                    );
                    return;
                  }

                  bool basarili = await kelimeEkle(
                    widget.listeId,
                    engText,
                    trText,
                    ornekText,
                  );

                  if (basarili) {
                    if (context.mounted) Navigator.pop(context);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Eklerken bir ağ hatası oluştu."),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  "Kelimeyi Kaydet",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // Tasarımı sade tutmak için kendi özel kutu widget'ımızı yaptık,
  Widget _ozelMetinKutusu(TextEditingController controller, String etiket) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: etiket,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
        ),
      ),
    );
  }
}
