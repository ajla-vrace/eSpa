import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/novost.dart';
import 'package:espa_mobile/models/novostInterakcija.dart';
import 'package:espa_mobile/models/novostKomentar.dart';
import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/novostInterakcija_provider.dart';
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
  late NovostInterakcijaProvider _novostInterakcijaProvider;
  late KorisnikProvider _korisnikProvider;
  int ukupnoKomentara = 0;
  bool? jeLajkovano;
  // ignore: unused_field
  bool _isLoading = true;
  late Korisnik? korisnik;
  String? korisnickoIme;
  NovostInterakcija? interakcija;
  SearchResult<Korisnik>? user;

  int? korisnikId;

  bool jeDislajkovano = false;
  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _novostInterakcijaProvider = context.read<NovostInterakcijaProvider>();
    _loadUserData();
    _loadSlika();
    _loadKomentari();
    // _loadUserData();
    //_provjeriJeLajkovano();
    // initialize();
  }

  void initialize() async {
    await _loadUserData();
    await _provjeriJeLajkovano();
  }

  Future<void> _loadUserData() async {
    // Dohvati korisničko ime iz SharedPreferences
    korisnickoIme = (await getUserName())!;
    print("getusername $korisnickoIme");
    // Ako korisničko ime nije null, nastavi sa dohvatanjem podataka o korisniku
    // ignore: unnecessary_null_comparison
    if (korisnickoIme != null) {
      try {
        print("u try smo za loadkorisnik");
        // Koristi provider za dohvatanje korisničkih podataka prema korisničkom imenu

        user = await _korisnikProvider
            .get(filter: {'KorisnickoIme': korisnickoIme});

        korisnik = user!.result.first;
        // korisnikId = user!.result[0].id;
        //await _provjeriJeLajkovano();
        // Ako su podaci uspešno učitani, update-uj state
        setState(() {
          korisnik = user!.result.first;
          korisnikId = user!.result.first.id;
        });
        if (korisnikId != null) {
          await _provjeriJeLajkovano();
          // await _toggleLajk();
          //await _toggleDislajk();
        }
      } catch (e) {
        // Ako dođe do greške prilikom učitavanja, možeš staviti fallback ili prikazati error poruku
        print("Greška pri učitavanju korisničkih podataka: $e");
      }
    }
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

  Future<void> _provjeriJeLajkovano() async {
    print(" u provjerilajkovano smo");
    print(
        "INTERAKCIJEEE->>>>>>>>>>>>>>>>>>>>${widget.novost.novostInterakcijas}");
    if (widget.novost.novostInterakcijas!.isNotEmpty) {
      print("u ifu smo je li interakcije null");
      print("KORISNID $korisnikId");
      print("novost ID ${widget.novost.id}");
      /*final interakcija = widget.novost.novostInterakcijas!.firstWhere(
          (f) => f.korisnikId == korisnikId && f.novostId == widget.novost.id);*/
      NovostInterakcija? interakcija = widget.novost.novostInterakcijas!
          .firstWhereOrNull((f) =>
              f.korisnikId == korisnikId && f.novostId == widget.novost.id);

      print("interkacijaaaaaaaaa $interakcija");
      //print("je li lajkovano bool ----------->$jeLajkovano");
      setState(() {
        jeLajkovano = interakcija?.isLiked == true;
        jeDislajkovano = interakcija?.isLiked == false;
      });
      print("jeLajkovano: $jeLajkovano");
      print("jeDislajkovano: $jeDislajkovano");
    }
  }

  Future<void> _toggleLajk() async {
    if (korisnikId == null) return;

    // Nađi postoji li već interakcija
    NovostInterakcija? existing = widget.novost.novostInterakcijas
        ?.firstWhereOrNull((x) => x.korisnikId == korisnikId);
    print("EXSISTING U TOGGLE LIKE -------------------------->$existing");
    try {
      if (existing != null) {
        if (existing.isLiked == true) {
          // Uklanjamo lajk
          await _novostInterakcijaProvider.delete(existing.id!);
          setState(() {
            widget.novost.novostInterakcijas!.remove(existing);
            jeLajkovano = false;
          });
        } else {
          // Bio je dislike → ažuriramo u like
          await _novostInterakcijaProvider.update(existing.id!, {
            "isLiked": true,
          });
          setState(() {
            existing.isLiked = true;
            jeLajkovano = true;
            jeDislajkovano = false;
          });
        }
      } else {
        // Nema interakcije → dodaj lajk
        final novaInterakcija = {
          "novostId": widget.novost.id,
          "korisnikId": korisnikId,
          "isLiked": true
        };
        final response =
            await _novostInterakcijaProvider.insert(novaInterakcija);
        setState(() {
          widget.novost.novostInterakcijas!.add(response);
          jeLajkovano = true;
          jeDislajkovano = false;
        });
      }
    } catch (e) {
      print("Greška u lajku: $e");
    }
  }

  Future<void> _toggleDislajk() async {
    if (korisnikId == null) return;

    // Nađi postoji li već interakcija
    NovostInterakcija? existing = widget.novost.novostInterakcijas
        ?.firstWhereOrNull((x) => x.korisnikId == korisnikId);
    print("EXSISTING U TOGGLE DISLIKE --------------->$existing");
    try {
      if (existing != null) {
        if (existing.isLiked == false) {
          // Uklanjamo dislajk
          await _novostInterakcijaProvider.delete(existing.id!);
          setState(() {
            widget.novost.novostInterakcijas!.remove(existing);
            jeDislajkovano = false;
          });
        } else {
          // Bio je lajk → ažuriramo u dislike
          await _novostInterakcijaProvider.update(existing.id!, {
            "isLiked": false,
          });
          setState(() {
            existing.isLiked = false;
            jeLajkovano = false;
            jeDislajkovano = true;
          });
        }
      } else {
        // Nema interakcije → dodaj dislajk
        final novaInterakcija = {
          "novostId": widget.novost.id,
          "korisnikId": korisnikId,
          "isLiked": false
        };
        final response =
            await _novostInterakcijaProvider.insert(novaInterakcija);
        setState(() {
          widget.novost.novostInterakcijas!.add(response);
          jeDislajkovano = true;
          jeLajkovano = false;
        });
      }
    } catch (e) {
      print("Greška u dislajku: $e");
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
                  return 'Treba imati karaktere';
                }

                final trimmed = value.trim();

                if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]').hasMatch(trimmed)) {
                  return 'Komentar mora početi slovom';
                }

                if (trimmed.length < 3) {
                  return 'Treba vise od 3 karaktera';
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
                    final komentarProvider =
                        context.read<NovostKomentarProvider>();

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
    final interakcije = widget.novost.novostInterakcijas ?? [];
    final brojLajkova = interakcije.where((x) => x.isLiked == true).length;
    final brojDislajkova = interakcije.where((x) => x.isLiked == false).length;

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
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child:
                      // ignore: unnecessary_null_comparison
                      (slikaBytes != null &&
                              slikaBytes!.isNotEmpty &&
                              slikaBytes!.length > 0)
                          ? Image.memory(
                              slikaBytes!,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 220,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey,
                              ),
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
                      //OVDJEEEEEEEEEEEEEEEEEEEE
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centriranje ikona
                        children: [
                          IconButton(
                            tooltip: "Like",
                            icon: Icon(
                              jeLajkovano == true
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: jeLajkovano == true
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: korisnikId != null ? _toggleLajk : null,
                          ),
                          // Dodajemo razmak između ikona i broja
                          SizedBox(width: 8),
                          Text(
                            '$brojLajkova', // Prikaz broja lajkova
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(116, 117, 118, 1),
                            ),
                          ),
                          SizedBox(
                              width: 16), // Razmak između lajk/dislajk ikona
                          IconButton(
                            tooltip: "Dislike",
                            icon: Icon(
                              jeDislajkovano == true
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_outlined,
                              color: jeDislajkovano == true
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: _toggleDislajk,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '$brojDislajkova', // Prikaz broja dislajkova
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(116, 117, 118, 1),
                            ),
                          ),
                        ],
                      ),

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
