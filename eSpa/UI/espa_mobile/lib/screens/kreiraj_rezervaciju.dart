import 'package:espa_mobile/models/rezervacija.dart';
import 'package:espa_mobile/models/usluga.dart';
import 'package:espa_mobile/providers/usluga_provider.dart';
import 'package:espa_mobile/providers/zaposlenik_provider.dart';
import 'package:espa_mobile/screens/paypal_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/termin.dart';
import '../providers/rezervacija_provider.dart';
import '../providers/termin_provider.dart';

class KreirajRezervacijuScreen extends StatefulWidget {
  final int korisnikId;
  final Usluga usluga;

  const KreirajRezervacijuScreen({
    super.key,
    required this.korisnikId,
    required this.usluga,
  });

  @override
  State<KreirajRezervacijuScreen> createState() =>
      _KreirajRezervacijuScreenState();
}

class _KreirajRezervacijuScreenState extends State<KreirajRezervacijuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _datumController = TextEditingController();
  // ignore: unused_field
  DateTime? _odabraniDatum;
  Termin? _odabraniTermin;
  List<Termin> _termini = []; // Lista svih termina
  List<dynamic> _zaposleniciUKategoriji = [];
  List<int> _slobodniTerminiIds = []; //dodano danas

  int? brojZauzetihZaposlenika;

  Iterable<Rezervacija> rezervacijeZaTermin = [];

  int? kategorijaId;

  Rezervacija? KreiranaRezervacija;

  double? iznos;

  var _napomenaController;

  @override
  void initState() {
    super.initState();
    _ucitajZaposlenikeIKategoriju();
  }

  Future<void> _ucitajZaposlenikeIKategoriju() async {
    try {
      final usluga = await context.read<UslugaProvider>().get(filter: {
        'Naziv': widget.usluga.naziv,
      });
      print("USLUGA  ${usluga}");
      var uslugaSama = usluga.result.first;
      print("USLUGA SAMA ${uslugaSama}");
      print("Naziv usluge: ${uslugaSama.naziv}");
      print("Kategorija ID: ${uslugaSama.kategorijaId}");
      print("Naziv kategorije: ${uslugaSama.kategorija.naziv}");
      print("usluga.kategorijaid   ${uslugaSama.kategorija.id}");
      kategorijaId = uslugaSama.kategorijaId;

      final sviZaposlenici =
          await context.read<ZaposlenikProvider>().get(filter: {
        'Kategorija': widget.usluga.kategorija.naziv,
        'Status': "Aktivan",
      });
      print("svi zaposlenici ${sviZaposlenici.count}");
      _zaposleniciUKategoriji = sviZaposlenici.result;
      // Ispis pojedinačno
      for (var zaposlenik in _zaposleniciUKategoriji) {
        print(
            'Zaposlenik: ${zaposlenik.korisnik.korisnickoIme}, KategorijaID: ${zaposlenik.kategorijaId}');
      }
      // _zaposleniciUKategoriji = sviZaposlenici.result;
    } catch (e) {
      debugPrint('Greška pri učitavanju zaposlenika: $e');
    }
  }

  // ignore: unused_element
  Future<int?> _nadjiSlobodnogZaposlenika(
      int terminId, int kategorijaId) async {
    try {
      // 1. Dohvati sve rezervacije za taj termin i kategoriju
      final rezervacije =
          await context.read<RezervacijaProvider>().get(filter: {
        'TerminId': terminId,
        'Datum': _odabraniDatum!.toIso8601String(),
        'Kategorija': widget.usluga.kategorija.naziv,
      });
      print('Rezervacije za termin $terminId: ${rezervacije.result.length}');

      // 2. Izvuci ZaposlenikId iz tih rezervacija (zauzeti)
      List<int> zauzetiZaposlenici =
          rezervacije.result.map((r) => r.zaposlenikId as int).toList();

      // 3. Dohvati sve zaposlenike u toj kategoriji
      final sviZaposlenici =
          await context.read<ZaposlenikProvider>().get(filter: {
        'Kategorija': widget.usluga.kategorija.naziv,
        'Status': "Aktivan",
      });

      // 4. Filtriraj da ostanu samo oni koji nisu zauzeti
      final slobodni = sviZaposlenici.result
          .where((zaposlenik) => !zauzetiZaposlenici.contains(zaposlenik.id))
          .toList();

      // 5. Vrati ID prvog slobodnog ako postoji
      if (slobodni.isNotEmpty) {
        print(
            'Slobodan zaposlenik: ${slobodni.first..korisnik!.korisnickoIme}');
        return slobodni.first.id;
      } else {
        print('Nema slobodnih zaposlenika!');
        return null;
      }
    } catch (e) {
      print('Greška pri traženju slobodnog zaposlenika: $e');
      return null;
    }
  }

  Future<void> _ucitajSlobodneTermineZaDatum(DateTime datum) async {
    try {
      // Dohvat usluge prema njenom nazivu
      final uslugaRaw = await context.read<UslugaProvider>().get(filter: {
        'Naziv': widget.usluga.naziv,
      });
      print("dobavljena usluga raw  $uslugaRaw");
      // ignore: unnecessary_null_comparison
      if (uslugaRaw == null) {
        throw Exception('Usluga nije pronađena.');
      }

      // Uzmi prvu uslugu (u ovom slučaju verovatno samo jedna)
      var uslugaSama = uslugaRaw.result.first;
      final kategorijaId = uslugaSama.kategorijaId;
      print("uslugama sama $uslugaSama");
      print("id kategorije $kategorijaId");
      // Dohvati sve zaposlene koji rade u toj kategoriji usluga
      final sviZaposlenici =
          await context.read<ZaposlenikProvider>().get(filter: {
        'Kategorija': widget.usluga.kategorija.naziv,
        'Status': "Aktivan",
      });

      // Dohvati sve rezervacije za taj datum
      print("odabrani datum---------------> $_odabraniDatum");
      final rezervacije =
          await context.read<RezervacijaProvider>().get(filter: {
        'Datum': _odabraniDatum!.toIso8601String(),
        'Kategorija': widget.usluga.kategorija.naziv,
      });
      print("rezervacije ${rezervacije.result}");
      print("=== Sve rezervacije ===");
      for (var r in rezervacije.result) {
        print(
            "Rezervacija ID: ${r.id}, TerminID: ${r.terminId}, Usluga: ${r.usluga?.id}, KategorijaID: ${r.usluga?.kategorijaId}");
      }

      // Dohvati sve termine koji su dostupni
      final sviTermini = await context.read<TerminProvider>().get();
      print("svi termini ${sviTermini.result}");
      // Lista slobodnih termina
      List<Termin> slobodniTermini = [];

      // Broj zaposlenih u toj kategoriji
      final brojZaposlenih = sviZaposlenici.result.length;
      print("broj zaposlenih $brojZaposlenih");
      print("KATEGORIJA ID JE $kategorijaId");

      for (var termin in sviTermini.result) {
        print(
            "Filtriram za termin ID: ${termin.id}, kategorija ID: $kategorijaId");
        // Filtriraj sve rezervacije za taj termin i uslugu
        rezervacijeZaTermin = rezervacije.result.where((r) =>
            r.terminId == termin.id &&
            r.usluga != null &&
            r.usluga!.kategorijaId == kategorijaId &&
            r.status != 'Otkazana');
        print(
            "Termin ID: ${termin.id} ima ${rezervacijeZaTermin.length} rezervacija");
        for (var rez in rezervacijeZaTermin) {
          print(
              " - Rezervacija ID: ${rez.id}, TerminID: ${rez.terminId}, KategorijaID: ${rez.usluga?.kategorijaId}");
        }
        brojZauzetihZaposlenika = rezervacijeZaTermin.length;
        //print("broj zauzetih zaposlenika $brojZauzetihZaposlenika");
        // Ako broj zauzetih zaposlenika nije prešao broj dostupnih zaposlenih za ovu kategoriju, termin je slobodan
        if (brojZauzetihZaposlenika! < brojZaposlenih) {
          slobodniTermini.add(termin);
        }
      }

      print("rezervacije za termin $rezervacijeZaTermin");
      print("broj zauzetih zaposlenika $brojZauzetihZaposlenika");
      print("slobodni temrini $slobodniTermini");
      // Ažuriraj UI sa slobodnim terminima
      /* setState(() {
        _termini = slobodniTermini;
        _odabraniTermin = null;
      });*/
      setState(() {
        _termini = sviTermini.result; // prikazujemo SVE termine
        _slobodniTerminiIds = slobodniTermini.map((t) => t.id!).toList();
        _odabraniTermin = null;
      }); //dodano danas
    } catch (e) {
      debugPrint('Greška pri dohvaćanju slobodnih termina: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _kreirajRezervaciju() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      int? zaposleniId;

      // Dohvati rezervacije za odabrani termin
      final rezervacijeZaTermin =
          await context.read<RezervacijaProvider>().get(filter: {
        'terminId': _odabraniTermin!.id,
        'Datum': _odabraniDatum!.toIso8601String(),
        'Kategorija': widget.usluga.kategorija.naziv,
      });

      final brojZauzetihZaposlenika = rezervacijeZaTermin.result.length;
      final brojZaposlenikaUKategoriji = _zaposleniciUKategoriji.length;

      // Ako su svi zaposleni zauzeti za ovaj termin, ne može se napraviti rezervacija
      /*if (brojZauzetihZaposlenika >= brojZaposlenikaUKategoriji) {
        throw Exception('Nema više dostupnih zaposlenika za odabrani termin');
      }*/ ////////////ovdjeeeeeeeeeeee

      // Izvuci već zauzete zaposlenike
      List<int> zauzetiZaposlenici =
          rezervacijeZaTermin.result.map((r) => r.zaposlenikId as int).toList();
      print("zauzeti zapslenici $zauzetiZaposlenici");
      // Pronađi prvog slobodnog zaposlenika
      /*final slobodanZaposlenik = _zaposleniciUKategoriji.firstWhere(
        (z) => !zauzetiZaposlenici.contains(z.id),
        orElse: () => null,
      );*/
      final slobodanZaposlenik = _zaposleniciUKategoriji.firstWhere(
        (z) => !zauzetiZaposlenici.contains(z.id),
        orElse: () =>
            throw Exception('Nema slobodnih zaposlenika za ovaj termin'),
      );

      print("slobodni zaposlenii $slobodanZaposlenik");
      if (slobodanZaposlenik != null) {
        zaposleniId = slobodanZaposlenik.id;
      } else {
        throw Exception('Nema slobodnih zaposlenika za ovaj termin');
      }

      // Kreiraj novu rezervaciju
      KreiranaRezervacija = await context.read<RezervacijaProvider>().insert({
        'korisnikId': widget.korisnikId,
        'uslugaId': widget.usluga.id,
        'datum': _odabraniDatum!.toIso8601String(),
        'terminId': _odabraniTermin!.id,
        'zaposlenikId': zaposleniId,
      });
      iznos = widget.usluga.cijena;
      print("kreirana rezervacija $KreiranaRezervacija");
      print("iznos $iznos");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rezervacija uspješno kreirana!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri kreiranju: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kreiraj rezervaciju')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _datumController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Odaberi datum',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today), // ← DODANO OVDJE
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _odabraniDatum = picked;
                      print("PICKED DATUM JE $picked");
                      _datumController.text =
                          "${picked.day}.${picked.month}.${picked.year}.";

                      _ucitajSlobodneTermineZaDatum(picked);
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Molimo odaberite datum'
                    : null,
              ),
              const SizedBox(height: 20),
              if (_termini
                  .isNotEmpty) // Prikazivanje Dropdown-a samo kad imamo slobodne termine

                DropdownButtonFormField<Termin>(
                  value: _odabraniTermin,
                  items: _termini.map((termin) {
                    bool jeSlobodan = _slobodniTerminiIds.contains(termin.id);
                    return DropdownMenuItem<Termin>(
                      value: jeSlobodan
                          ? termin
                          : null, // zauzeti su null, pa se ne mogu kliknuti
                      enabled:
                          jeSlobodan, // ovo sprečava selektovanje ako je false
                      child: Text(
                        termin.pocetak!, // ili formatirano vreme npr. "09:00"
                        style: TextStyle(
                          color: jeSlobodan ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _odabraniTermin = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Odaberite termin',
                    border: OutlineInputBorder(),
                  ),
                ),
//dodano danas

              const SizedBox(height: 30),
             

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: (_odabraniDatum != null && _odabraniTermin != null)
                    ? () async {
                        final bool? potvrda = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Potvrda rezervacije'),
                              content: const Text(
                                  'Jeste li sigurni da želite rezervisati?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Ne'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Da'),
                                ),
                              ],
                            );
                          },
                        );

                        if (potvrda == true) {
                          // ✅ Sačekaj da se rezervacija kreira
                          await _kreirajRezervaciju();

                          // ✅ Provjeri je li uspješno kreirana
                          if (KreiranaRezervacija != null) {
                            print(
                                "Kreirana rezervacija je: $KreiranaRezervacija");

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PayPalScreen(
                                  lastRezervacija: KreiranaRezervacija,
                                  totalAmount: iznos!,
                                ),
                              ),
                            );

                            if (result == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Plaćanje uspješno!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Plaćanje otkazano.')),
                              );
                            }
                          }
                        }
                      }
                    : null,
                child: const Text('Rezerviši'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
