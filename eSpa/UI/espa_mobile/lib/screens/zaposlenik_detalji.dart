import 'dart:convert';
import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/models/zaposlenikRecenzija.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/zaposlenikRecenzija_provider.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/zaposlenik.dart';
import '../widgets/master_screen.dart';

class ZaposlenikDetaljiScreen extends StatefulWidget {
  final Zaposlenik zaposlenik;

  const ZaposlenikDetaljiScreen({super.key, required this.zaposlenik});

  @override
  State<ZaposlenikDetaljiScreen> createState() =>
      _ZaposlenikDetaljiScreenState();
}

class _ZaposlenikDetaljiScreenState extends State<ZaposlenikDetaljiScreen> {
  List<ZaposlenikRecenzija> _recenzije = [];
  bool _isLoading = true;

  int ukupnoKomentara = 0;

  String? korisnickoIme;

  SearchResult<Korisnik>? user;

  int? korisnikId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRecenzije();
  }

  Future<void> _loadRecenzije() async {
    try {
      final komentarProvider = context.read<ZaposlenikRecenzijaProvider>();
      final komentari = await komentarProvider.get(filter: {
        'zaposlenik': widget.zaposlenik.korisnik!.korisnickoIme,
      });

      setState(() {
        _recenzije = komentari.result;
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
    int _ocjena = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Dodaj recenziju'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Zvjezdice za ocjenu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _ocjena ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocjena = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  if (_ocjena == 0)
                    const Text(
                      'Ocjena je obavezna',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  // Polje za komentar
                  TextFormField(
                    controller: _komentarController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Unesite vaš komentar (opcionalno)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final trimmed = value.trim();
                        if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]').hasMatch(trimmed)) {
                          return 'Komentar mora početi slovom';
                        }
                        if (trimmed.length < 3) {
                          return 'Komentar mora imati najmanje 3 znaka';
                        }
                      }
                      return null; // Komentar je opcionalan
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Otkaži'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_ocjena == 0) {
                    setState(() {}); // Osveži UI da bi prikazao error za ocjenu
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    try {
                      final komentarProvider =
                          context.read<ZaposlenikRecenzijaProvider>();

                      await komentarProvider.insert({
                        'komentar': _komentarController.text,
                        'ocjena': _ocjena,
                        'zaposlenikId': widget.zaposlenik.id,
                        'korisnikId': korisnikId,
                      });

                      Navigator.of(context).pop();
                      _loadRecenzije();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Recenzija uspješno dodana.'),
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
        });
      },
    );
  }

  /*void _showAddKomentarDialog() {
    final _formKey = GlobalKey<FormState>();
    final _komentarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dodaj recenziju'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _komentarController,
              maxLines: 3,
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
                    final komentarProvider =
                        context.read<ZaposlenikRecenzijaProvider>();

                    await komentarProvider.insert({
                      'komentar': _komentarController.text,
                      'ocjena': 1,
                      'zaposlenikId': widget.zaposlenik.id,
                      'korisnikId': korisnikId,
                    });

                    Navigator.of(context).pop();
                    _loadRecenzije(); // Osvježi komentare

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recenzija uspješno dodana.'),
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
  }*/

  @override
  Widget build(BuildContext context) {
    final slikaBytes = widget.zaposlenik.slika?.slika != null &&
            widget.zaposlenik.slika!.slika!.isNotEmpty
        ? base64Decode(widget.zaposlenik.slika!.slika!)
        : null;

    return MasterScreenWidget(
      title: "Zaposlenik detalji",
      selectedIndex: 1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.teal, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: slikaBytes != null
                              ? MemoryImage(slikaBytes)
                              : null,
                          // ignore: sort_child_properties_last
                          child: slikaBytes == null
                              ? const Icon(Icons.person,
                                  size: 60, color: Colors.teal)
                              : null,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.zaposlenik.korisnik?.ime ?? ''} ${widget.zaposlenik.korisnik?.prezime ?? ''}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    /*const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),*/
                    Row(
                      children: [
                        const Icon(Icons.work_outline, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          widget.zaposlenik.struka ?? 'Nepoznata struka',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),
                    const Text(
                      'Biografija',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.description, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.zaposlenik.biografija ??
                                'Nema biografije dostupne.',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),
                    const Text(
                      'Datum zaposlenja',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          widget.zaposlenik.datumZaposlenja != null
                              ? DateFormat('dd.MM.yyyy')
                                  .format(widget.zaposlenik.datumZaposlenja!)
                              : 'Nepoznati datum',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),
                    const Text(
                      'Kontakt informacije',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          widget.zaposlenik.korisnik?.telefon ??
                              'Nepoznat telefon',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          widget.zaposlenik.korisnik?.email ?? 'Nepoznat email',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    /*const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          widget.zaposlenik.korisnik?.email ?? 'Nepoznat email',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),*/
                    //const SizedBox(height: 16),
                    const Divider(color: Colors.teal, thickness: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recenzije',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.add_comment, color: Colors.teal),
                          onPressed: () {
                            _showAddKomentarDialog();
                          },
                        ),
                      ],
                    ),
                    Text(
                      'Ukupno recenzija: $ukupnoKomentara',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_recenzije.isEmpty)
                      const Text('Nema dostupnih recenzija.')
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._recenzije.reversed.map((recenzija) => Container(
                                margin: const EdgeInsets.only(
                                    bottom: 12), // Razmak između recenzija
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .grey[100], // Boja pozadine pravougaonika
                                  borderRadius: BorderRadius.circular(
                                      10), // Zaobljeni kutovi
                                  border: Border.all(
                                      color:
                                          Colors.grey.shade300), // Boja ivica
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Korisničko ime i datum
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Razdvaja elemente na suprotnim stranama
                                      children: [
                                        // Korisničko ime, koje će biti na levoj strani
                                        Expanded(
                                          child: Text(
                                            recenzija.korisnik?.korisnickoIme ??
                                                'Nepoznati korisnik',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis, // Dodajemo elipsu ako je tekst predugačak
                                            maxLines:
                                                1, // Ograničavamo na 1 liniju
                                          ),
                                        ),

                                        // Datum, koji će biti na desnoj strani
                                        const SizedBox(
                                            width:
                                                12), // Razmak između korisničkog imena i datuma
                                        Text(
                                          recenzija.datumKreiranja != null
                                              ? DateFormat('dd.MM.yyyy').format(
                                                  recenzija.datumKreiranja!)
                                              : 'Nepoznat datum',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Ocjena sa zvjezdicama
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < recenzija.ocjena!
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),

                                    const SizedBox(height: 8),

                                    // Komentar
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /*const Icon(Icons.comment,
                                            color: Colors.grey),
                                        const SizedBox(width: 8),*/
                                        Expanded(
                                          child: Text(
                                            recenzija.komentar ?? 'Bez teksta',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 8),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
