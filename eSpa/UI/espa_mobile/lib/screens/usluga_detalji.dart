import 'dart:convert';
import 'dart:typed_data';
import 'package:espa_mobile/models/favorit.dart';
import 'package:espa_mobile/models/komentar.dart';
import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/ocjena.dart';
import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/providers/favorit_provider.dart';
import 'package:espa_mobile/providers/komentar_provider.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/ocjena_provider.dart';
import 'package:espa_mobile/providers/usluga_provider.dart';
import 'package:espa_mobile/screens/kreiraj_rezervaciju.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:espa_mobile/models/usluga.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UslugaDetailScreen extends StatefulWidget {
  final Usluga usluga;

  const UslugaDetailScreen({super.key, required this.usluga});

  @override
  State<UslugaDetailScreen> createState() => _UslugaDetailScreenState();
}

class _UslugaDetailScreenState extends State<UslugaDetailScreen> {
  Uint8List? slikaBytes;
  // ignore: unused_field
  bool? _isLoading = true;
  // ignore: unused_field
  bool? _isLoadingOcjene = true;
  List<Komentar>? _komentari;
  List<Ocjena>? _ocjene;
  int? ukupnoKomentara = 0;
  late String korisnickoIme;
  SearchResult<Korisnik>? user;
  Korisnik? korisnik;
  int? korisnikId;
  late FavoritProvider _favoritProvider;
  late KorisnikProvider _korisnikProvider;
  //bool _jeFavorit = false;
  List<Favorit>? data = [];
  var dataKorisnik;
  List<Usluga> _recommended = [];

  bool _prikaziPreporuke = false;
  // ignore: unused_field
  List<Usluga> _preporuceneUsluge = [];
  bool jeFavoritBool = false;

  UslugaProvider? _uslugaProvider;
  double? getProsjecnaOcjena() {
    if (_ocjene == null || _ocjene!.isEmpty) return null;
    double suma = _ocjene!
        .map((o) => (o.ocjena1 ?? 0).toDouble())
        .reduce((a, b) => a + b);
    return suma / _ocjene!.length;
  }

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _favoritProvider = context.read<FavoritProvider>();
    _uslugaProvider = context.read<UslugaProvider>();
    _loadUserData();
    _loadSlika();
    _loadKomentari();
    _loadOcjene();
    // _loadRecommended();

    // _provjeriFavorit();
  }

/*void initialoze() async{
  await _loadUserData();
  await _provjeriFavorit();

  }*/
  void _loadSlika() {
    if (widget.usluga.slika != null && widget.usluga.slika!.isNotEmpty) {
      try {
        slikaBytes = base64Decode(widget.usluga.slika!);
      } catch (e) {
        slikaBytes = null;
      }
    }
  }

  Future<void> _loadKomentari() async {
    try {
      final komentarProvider = context.read<KomentarProvider>();
      final komentari = await komentarProvider.get(filter: {
        'usluga': widget.usluga.naziv,
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

  Future<void> _loadOcjene() async {
    try {
      final ocjenaProvider = context.read<OcjenaProvider>();
      final ocjene = await ocjenaProvider.get(filter: {
        'usluga': widget.usluga.naziv,
      });

      setState(() {
        _ocjene = ocjene.result;
        _isLoadingOcjene = false;
      });
    } catch (e) {
      print("Greška pri dohvaćanju ocjena: $e");
      setState(() => _isLoadingOcjene = false);
    }
  }

  Future<void> _loadUserData() async {
    // Dohvati korisničko ime iz SharedPreferences
    korisnickoIme = (await getUserName())!;
    print("KORISNICKO IME: $korisnickoIme");
    // Ako korisničko ime nije null, nastavi sa dohvatanjem podataka o korisniku
    // ignore: unnecessary_null_comparison
    if (korisnickoIme != null) {
      try {
        // Koristi provider za dohvatanje korisničkih podataka prema korisničkom imenu

        user = await _korisnikProvider
            .get(filter: {'KorisnickoIme': korisnickoIme});
        // Ako su podaci uspešno učitani, update-uj state
        korisnikId = user!.result[0].id;
        setState(() {
          korisnikId = user!.result[0].id;
          print("korisnik id----------------> $korisnikId");
          korisnik = user!.result[0];
          print("korisnik ------------------>$korisnik");
        });
        if (korisnikId != null) {
          await _loadRecommended();
          await _provjeriFavorit();
        }
      } catch (e) {
        print("greska na load korisnik --------> ${e.toString()}");
        // Ako dođe do greške prilikom učitavanja, možeš staviti fallback ili prikazati error poruku
        print("Greška pri učitavanju korisničkih podataka: $e");
      }
    }
  }

  Future<void> _loadRecommended() async {
    if (widget.usluga.id == null || korisnikId == null) {
      print("usluga id ${widget.usluga.id}");
      print("korisnik id $korisnikId");
      //return;
    }
    if (widget.usluga.id != null && korisnikId != null) {
      try {
        var data = await _uslugaProvider!
            .getRecommended(widget.usluga.id!, korisnikId!);
        print("DATA ------------->$data");
        setState(() {
          _recommended = data;
        });
      } catch (e) {
        print("Greška pri dohvaćanju preporuka: $e");
      }
    }
  }

  Future<void> _toggleFavorit() async {
    if (jeFavoritBool) {
      print("u jefavoriboll true smo");
      // Ako već postoji, pronađi ID favorita
      final favorit = widget.usluga.favorits!.firstWhere(
          (f) => f.korisnikId == korisnikId && f.uslugaId == widget.usluga.id);
      print("FINAL FAVORIT ---------------> $favorit");
      // Pozovi DELETE na API
      await _favoritProvider
          .delete(favorit.id!); // prilagodi naziv metodi i servisu
      setState(() {
        widget.usluga.favorits!.remove(favorit);
        print("WIDGE:FAVORITS ${widget.usluga.favorits}");
        jeFavoritBool = false;
      });
    } else {
      // Dodaj novi favorit
      final favoritData = {
        "korisnikId": korisnikId,
        "uslugaId": widget.usluga.id,
        "isFavorit": true
      };
      print("FAVORIT DATA -------------->$favoritData");
      final noviFavorit = await _favoritProvider.insert(favoritData);

      /*final noviFavorit = await _favoritProvider
          .insert({"korisnikId": korisnikId, "uslugaId": widget.usluga.id});*/

      setState(() {
        widget.usluga.favorits!.add(noviFavorit);
        print(
            "FAVORITI NAKON INSERT --------------> ${widget.usluga.favorits}");
        jeFavoritBool = true;
      });
    }
  }

  Future<void> _provjeriFavorit() async {
    print(" u provjeriFavorit smo");
    print("FAVORITSSSSS->>>>>>>>>>>>>>>>>>>>${widget.usluga.favorits}");
    if (widget.usluga.favorits != null) {
      print("u ifu smo je li favorits null");
      print("KORISNID $korisnikId");
      print("USLUGA ID ${widget.usluga.id}");
      jeFavoritBool = widget.usluga.favorits!.any(
          (f) => f.korisnikId == korisnikId && f.uslugaId == widget.usluga.id);

      print("je li favorit bool ----------->$jeFavoritBool");
    }
  }

  void _showAddOcjenaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int selectedOcjena = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ocijeni uslugu'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedOcjena
                                ? Icons.star
                                : Icons.star_border,
                            color: index < selectedOcjena
                                ? Colors.yellow
                                : Colors.grey,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedOcjena = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Tvoja ocjena: $selectedOcjena'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Otkaži'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedOcjena == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Odaberi ocjenu prije slanja.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      final ocjenaProvider = context.read<OcjenaProvider>();
                      await ocjenaProvider.insert({
                        'korisnikId': korisnikId,
                        'uslugaId': widget.usluga.id,
                        'ocjena1': selectedOcjena,
                      });

                      Navigator.of(context).pop();
                      _loadOcjene();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ocjena uspješno dodana!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Greška pri slanju ocjene.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Dodaj'),
                ),
              ],
            );
          },
        );
      },
    );
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
                if (value!.isEmpty) {
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
                    final komentarProvider = context.read<KomentarProvider>();

                    await komentarProvider.insert({
                      'korisnikId': korisnikId,
                      'uslugaId': widget.usluga.id,
                      'tekst': _komentarController.text,
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

  String formatCijena(double? cijena) {
    if (cijena == null) return "N/A";
    return "${cijena.toStringAsFixed(2)} KM";
  }

  String formatTrajanje(String? trajanje) {
    if (trajanje == null) return "Nepoznato trajanje";
    return "$trajanje min";
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Usluga detalji',
      selectedIndex: 1,
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
                // Slika usluge
                Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: slikaBytes != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Image.memory(
                                slikaBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 220,
                              ),
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          jeFavoritBool
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: jeFavoritBool ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          _toggleFavorit();
                        },
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Naziv usluge
                      Text(
                        widget.usluga.naziv ?? "Bez naziva",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (_ocjene != null)
                        Row(
                          children: [
                            // Zvjezdice
                            ...List.generate(5, (index) {
                              double prosjek = getProsjecnaOcjena() ??
                                  0.0; // Postavi prosjek na 0 ako nije definisan
                              return Icon(
                                index < prosjek.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color.fromARGB(255, 219, 235, 53),
                                size: 24,
                              );
                            }),

                            const SizedBox(width: 8),

                            // Broj ocjena (ako nema ocjena, piše 0)
                            Text(
                              '(${_ocjene!.isNotEmpty ? _ocjene!.length : 0})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Ikonica za dodavanje nove ocjene
                            IconButton(
                              icon: const Icon(
                                  Icons.star_border_purple500_outlined),
                              tooltip: 'Dodaj ocjenu',
                              color: Colors.teal,
                              onPressed: _showAddOcjenaDialog,
                            ),
                          ],
                        ),

                      const SizedBox(height: 6),
                      // Trajanje
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 20, color: Colors.teal),
                          const SizedBox(width: 6),
                          Text(
                            formatTrajanje(widget.usluga.trajanje),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Cijena
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              size: 20, color: Colors.teal),
                          const SizedBox(width: 6),
                          Text(
                            formatCijena(widget.usluga.cijena),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),
// Dugme za rezervaciju termina
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Ovdje ide logika za otvaranje forme za rezervaciju
                            // Na primjer: Navigator.push(...);
                            if (korisnikId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KreirajRezervacijuScreen(
                                    korisnikId: korisnikId!,
                                    usluga: widget.usluga,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text("Rezerviši termin"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Opis",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Opis usluge
                      Text(
                        widget.usluga.opis ?? "Bez opisa",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      //const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),

                      /* Text(
                        "Komentari",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      */

// Dugme za prikaz preporuka
                      /*   ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _prikaziPreporuke = !_prikaziPreporuke;
                          });
                        },
                        icon: Icon(Icons.recommend),
                        label: Text(_prikaziPreporuke
                            ? "Sakrij preporuke"
                            : "Prikaži preporuke"),
                      ),

// Horizontalni prikaz preporuka
                      Visibility(
                        visible: _prikaziPreporuke,
                        child: Container(
                          height: 180,
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _recommended.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final usluga = _recommended[index];
                              return Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.teal),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Opcionalno: otvori detalje usluge
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                        child: (usluga.slika != null &&
                                                usluga.slika != "")
                                            ? Image.memory(
                                                base64Decode(usluga.slika!),
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.cover)
                                            : Container(
                                                height: 100,
                                                color: Colors.grey[200],
                                                //width: double.infinity,
                                                child: const Icon(
                                                    Icons.image_not_supported),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          usluga.naziv ?? 'Bez naziva',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),*/

                      Text(
                        "Ukupno komentara: ${ukupnoKomentara ?? 0}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Komentari",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_comment,
                                color: Colors.teal),
                            onPressed: () {
                              _showAddKomentarDialog();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      // _komentari!.isEmpty
                      (_komentari?.isEmpty ?? true)
                          ? const Text("Nema komentara za ovu uslugu.")
                          : Column(
                              children: _komentari!.reversed.map((komentar) {
                                final autor =
                                    "${komentar.korisnik!.ime ?? ''} ${komentar.korisnik!.prezime ?? ''}";
                                final datum = komentar.datum != null
                                    ? DateFormat('dd.MM.yyyy')
                                        .format(komentar.datum!)
                                    : 'Nepoznat datum';

                                return Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.9, // fiksna širina
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: const Color.fromARGB(
                                              255,
                                              22,
                                              65,
                                              45), // ili npr. Colors.red, ili Color(0xFF123456)
                                          width: 1.5, // debljina linije
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              autor,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              datum,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              komentar.tekst ?? '',
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _prikaziPreporuke = !_prikaziPreporuke;
                          });
                        },
                        icon: Icon(Icons.recommend),
                        label: Text(_prikaziPreporuke
                            ? "Sakrij preporuke"
                            : "Prikaži preporuke"),
                      ),
// Preporuke
                      if (_prikaziPreporuke)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              "Preporučene usluge:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal),
                            ),
                            const SizedBox(height: 8),
                            _recommended.isEmpty
                                ? const Text("Trenutno nema preporuka za vas.")
                                : Container(
                                    height: 180,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _recommended.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 12),
                                      itemBuilder: (context, index) {
                                        final usluga = _recommended[index];
                                        Widget imageWidget;

                                        try {
                                          if (usluga.slika != null &&
                                              usluga.slika!.isNotEmpty) {
                                            imageWidget = Image.memory(
                                              base64Decode(usluga.slika!),
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            imageWidget = const Icon(
                                                Icons.image_not_supported);
                                          }
                                        } catch (e) {
                                          imageWidget =
                                              const Icon(Icons.broken_image);
                                        }

                                        return Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border:
                                                Border.all(color: Colors.teal),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 6,
                                                offset: const Offset(0, 4),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // Opcionalno: otvori detalje usluge
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      UslugaDetailScreen(
                                                          usluga:
                                                              widget.usluga),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                              .vertical(
                                                          top: Radius.circular(
                                                              12)),
                                                  child: Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    color: Colors.grey[200],
                                                    child: Center(
                                                        child: imageWidget),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    usluga.naziv ??
                                                        'Bez naziva',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
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
