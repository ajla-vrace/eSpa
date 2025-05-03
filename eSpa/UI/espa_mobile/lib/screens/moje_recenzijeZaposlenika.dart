import 'package:espa_mobile/models/zaposlenikRecenzija.dart';
import 'package:espa_mobile/providers/zaposlenikRecenzija_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:espa_mobile/utils/util.dart';

class MojeRecenzijeZaposlenikaScreen extends StatefulWidget {
  const MojeRecenzijeZaposlenikaScreen({super.key});

  @override
  State<MojeRecenzijeZaposlenikaScreen> createState() =>
      _MojeRecenzijeZaposlenikaScreenState();
}

class _MojeRecenzijeZaposlenikaScreenState
    extends State<MojeRecenzijeZaposlenikaScreen> {
  List<ZaposlenikRecenzija> recenzije = [];
  bool isLoading = true;
  int brojRecenzija = 0;
  late ZaposlenikRecenzijaProvider _recenzijaProvider;

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
      _recenzijaProvider = context.read<ZaposlenikRecenzijaProvider>();
      final data = await _recenzijaProvider.get(filter: {
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

  Widget buildStars(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 24,
        ),
      );
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moje recenzije zaposlenika",
      selectedIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Moje recenzije zaposlenika',
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
                  "Nemate nijednu recenziju zaposlenika.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            // const Text("Nemate nijednu recenziju.")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recenzije.length,
                itemBuilder: (context, index) {
                  final recenzija = recenzije[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  recenzija.zaposlenik!.korisnik!.ime ??
                                      "Nepoznat zaposlenik",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Uredi ocjenu',
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 35, 96, 59)),
                                onPressed: () async {
                                  double currentRating =
                                      recenzija.ocjena!.toDouble();
                                  TextEditingController komentarController =
                                      TextEditingController(
                                          text: recenzija.komentar ?? "");
                                  final _formKey = GlobalKey<
                                      FormState>(); // Dodajemo ključ za validaciju forme

                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: const Text('Uredi ocjenu'),
                                            content: Form(
                                              key:
                                                  _formKey, // Dodajemo Form widget
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: List.generate(5,
                                                        (index) {
                                                      return IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            currentRating =
                                                                (index + 1)
                                                                    .toDouble();
                                                          });
                                                        },
                                                        icon: Icon(
                                                          index < currentRating
                                                              ? Icons.star
                                                              : Icons
                                                                  .star_border,
                                                          color: Colors.yellow,
                                                          size: 32,
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  // Polje za unos komentara
                                                  TextFormField(
                                                      controller:
                                                          komentarController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Komentar (opcionalno)',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      maxLines: 3,
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      validator: (value) {
                                                        // Ako je komentar prazan, dozvoljava se
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return null;
                                                        } else if (value
                                                            .trim()
                                                            .isEmpty) {
                                                          // Ako je komentar samo sa razmacima
                                                          return 'Komentar ne može imati samo razmake';
                                                        } else if (value
                                                                .trim()
                                                                .length <
                                                            3) {
                                                          // Ako je komentar prekratak (manje od 3 karaktera)
                                                          return 'Komentar mora imati najmanje 3 karaktera';
                                                        }
                                                        return null; // Ako nema problema sa komentarom, vraća null (validno je)
                                                      }
                                                      ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // zatvori dijalog
                                                },
                                                child: const Text('Otkaži'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    // Provjeri validaciju forme
                                                    try {
                                                      await _recenzijaProvider
                                                          .update(
                                                        recenzija.id!,
                                                        {
                                                          'ocjena':
                                                              currentRating
                                                                  .round(),
                                                          'komentar': komentarController
                                                                  .text
                                                                  .trim()
                                                                  .isEmpty
                                                              ? null // Ako je komentar prazan, ne šaljemo ga
                                                              : komentarController
                                                                  .text
                                                                  .trim(),
                                                        },
                                                      );

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Recenzija uspješno ažurirana."),
                                                          backgroundColor:
                                                              Colors.green,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ),
                                                      );
                                                      await _loadRecenzije();
                                                      Navigator.pop(context);
                                                    } catch (e) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Greška"),
                                                            content: Text(
                                                                e.toString()),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                        "OK"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                                child: const Text('Spasi'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: 'Izbriši recenziju',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Potvrda brisanja"),
                                        content: const Text(
                                            "Da li ste sigurni da želite obrisati ovu recenziju?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Odustani"),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.grey),
                                          ),
                                          TextButton(
                                            child: const Text("Obriši"),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.red),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    try {
                                      await _recenzijaProvider
                                          .delete(recenzija.id!);

                                      setState(() {
                                        recenzije.remove(recenzija);
                                        brojRecenzija = recenzije.length;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Recenzija uspješno obrisana.",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Greška prilikom brisanja recenzije."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          buildStars(recenzija.ocjena!
                              .toDouble()), // Prikaz zvjezdica ocjene
                          const SizedBox(height: 4),
                          Text(
                            recenzija.komentar ??
                                "", // Ako nema komentara, prikažemo poruku "Nema komentara"
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(recenzija.datumKreiranja),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
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
