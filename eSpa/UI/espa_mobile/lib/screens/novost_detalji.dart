import 'dart:convert';
import 'dart:typed_data';
import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/novost.dart';
import 'package:espa_mobile/models/novostKomentar.dart';
import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/novostKomentar_provider.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NovostDetailScreen extends StatefulWidget {
  final Novost novost;
  const NovostDetailScreen({super.key, required this.novost});

  @override
  State<NovostDetailScreen> createState() => _NovostDetailScreenState();
}

class _NovostDetailScreenState extends State<NovostDetailScreen> {
  Uint8List? slikaBytes;
  List<NovostKomentar> komentari = [];

  List<NovostKomentar>? _komentari;

  int ukupnoKomentara = 0;

  // ignore: unused_field
  bool _isLoading = true;
  
  String? korisnickoIme;

  SearchResult<Korisnik>? user;
  
  int? korisnikId;
  @override
  void initState() {
    super.initState();

    _loadSlika();
    _loadKomentari();
    _loadUserData();
  }

  void _loadSlika() {
    if (widget.novost.slika != null) {
      try {
        slikaBytes = base64Decode(widget.novost.slika!);
      } catch (e) {
        slikaBytes = null;
      }
    }
  }

  Future<void> _loadKomentari() async {
    try {
      final komentarProvider = context.read<NovostKomentarProvider>();
      final komentari = await komentarProvider.get(filter: {
        'novost': widget.novost.naslov,
      });

      setState(() {
        _komentari = komentari.result;
        ukupnoKomentara = komentari.count;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

Future<void> _loadUserData() async {
    // Dohvati korisničko ime iz SharedPreferences
    korisnickoIme = (await getUserName())!;
    // Ako korisničko ime nije null, nastavi sa dohvatanjem podataka o korisniku
    // ignore: unnecessary_null_comparison
    if (korisnickoIme != null) {
      try {
        // Koristi provider za dohvatanje korisničkih podataka prema korisničkom imenu
        var korisniciProvider = context.read<KorisnikProvider>();
        user = await korisniciProvider
            .get(filter: {'korisnickoIme': korisnickoIme});
        // Ako su podaci uspešno učitani, update-uj state
        setState(() {
          korisnikId = user!.result[0].id;
        });
      } catch (e) {
        // Ako dođe do greške prilikom učitavanja, možeš staviti fallback ili prikazati error poruku
        print("Greška pri učitavanju korisničkih podataka: $e");
      }
    }
  }

void _showAddKomentarDialog() {
    final _formKey = GlobalKey<FormState>();
    final _komentarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dodaj komentar'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _komentarController,
              maxLines: 3,
               autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: 'Unesite vaš komentar',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Komentar ne može biti prazan';
                }
                if (value.trim().isEmpty) {
                  return 'Komentar ne može imati samo razmake';
                }

                final trimmed = value.trim();

                if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]').hasMatch(trimmed)) {
                  return 'Komentar mora početi slovom';
                }

                if (trimmed.length < 3) {
                  return 'Komentar mora imati najmanje 3 znaka';
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Otkaži'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final komentarProvider = context.read<NovostKomentarProvider>();

                    await komentarProvider.insert({
                      'korisnikId': korisnikId,
                      'novostId': widget.novost.id,
                      'sadrzaj': _komentarController.text,
                    });

                    Navigator.of(context).pop();
                    _loadKomentari(); // Osvježi komentare

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Komentar uspješno dodan.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Greška: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Dodaj'),
            ),
          ],
        );
      },
    );
  }


  String formatDatum(DateTime? datum) {
    if (datum == null) return "Nepoznat datum";
    return DateFormat('dd-MM-yyyy').format(datum);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Novost detalji',
      selectedIndex: 0,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (slikaBytes != null)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.memory(
                      slikaBytes!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.novost.naslov ?? "Bez naslova",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            widget.novost.autor?.korisnickoIme ??
                                "Nepoznat autor",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            formatDatum(widget.novost.datumKreiranja),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),
                      Text(
                        widget.novost.sadrzaj ?? "Bez sadržaja",
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Komentari',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_comment, 
                            color: Colors.teal),
                            tooltip: 'Dodaj komentar',
                            onPressed: () => _showAddKomentarDialog(),
                          ),
                        ],
                      ),
                      Text(
                        '$ukupnoKomentara komentara',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      if (_komentari == null || _komentari!.isEmpty)
                        const Text('Još nema komentara.')
                      else
                        Column(
                          children: _komentari!.reversed.map((komentar) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    komentar.korisnik!.korisnickoIme ??
                                        'Nepoznat korisnik',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    komentar.sadrzaj ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd.MM.yyyy HH:mm').format(
                                        komentar.datumKreiranja ??
                                            DateTime.now()),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
