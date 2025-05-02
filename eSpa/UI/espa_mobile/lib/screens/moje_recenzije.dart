import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/models/komentar.dart';
import 'package:espa_mobile/providers/komentar_provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:espa_mobile/utils/util.dart';

class MojeRecenzijeScreen extends StatefulWidget {
  const MojeRecenzijeScreen({super.key});

  @override
  State<MojeRecenzijeScreen> createState() => _MojeRecenzijeScreenState();
}

class _MojeRecenzijeScreenState extends State<MojeRecenzijeScreen> {
  List<Komentar> recenzije = [];
  bool isLoading = true;
  int brojRecenzija = 0;

  String formatDate(DateTime? date) {
    if (date == null) return "Nepoznato";
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}.";
  }

  @override
  void initState() {
    super.initState();
    _loadRecenzije();
  }

  Future<void> _loadRecenzije() async {
    final korisnickoIme = await getUserName();
    if (korisnickoIme != null) {
      final recenzijaProvider = context.read<KomentarProvider>();
      final data = await recenzijaProvider.get(filter: {
        'korisnik': korisnickoIme,
      });

      setState(() {
        recenzije = data.result;
        brojRecenzija = data.count;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moje recenzije",
      selectedIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Moje recenzije',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Ukupno recenzija: $brojRecenzija',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (recenzije.isEmpty)
              const Center(
                child: Text(
                  "Nemate nijednu recenziju.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            // const Text("Nemate nijednu recenziju.")
            else
              /*ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recenzije.length,
                itemBuilder: (context, index) {
                  final recenzija = recenzije[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Datum gore desno
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                formatDate(recenzija.datum),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Ikonica levo, a sve ostalo pored nje
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.rate_review,
                                    color: Colors.green, size: 30),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Naziv usluge
                                      Text(
                                        recenzija.usluga?.naziv ??
                                            "Nepoznata usluga",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Tekst recenzije
                                      Text(
                                        recenzija.tekst ?? "Nema teksta",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),*/
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recenzije.length,
                itemBuilder: (context, index) {
                  final recenzija = recenzije[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Datum gore desno + ikonica za brisanje
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    formatDate(recenzija.datum),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                // Ikonica za brisanje
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      // Dodajte logiku za brisanje recenzije
                                     // await  jfnjk(recenzija);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Ikonica levo, a sve ostalo pored nje
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.rate_review,
                                    color: Colors.green, size: 30),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Naziv usluge
                                      Text(
                                        recenzija.usluga?.naziv ??
                                            "Nepoznata usluga",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Tekst recenzije
                                      Text(
                                        recenzija.tekst ?? "Nema teksta",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
