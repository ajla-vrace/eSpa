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
  late KomentarProvider _recenzijaProvider;

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
      _recenzijaProvider = context.read<KomentarProvider>();
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recenzije.length,
                itemBuilder: (context, index) {
                  final recenzija = recenzije.reversed.toList()[index];
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
                                  recenzija.usluga!.naziv ?? "Nepoznata usluga",
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
                                tooltip: 'Uredi komentar',
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 35, 96, 59)),
                                onPressed: () async {
                                  final _formKey = GlobalKey<FormState>();
                                  final TextEditingController _controller =
                                      TextEditingController(
                                          text: recenzija.tekst);
                                  String originalText = recenzija.tekst ?? '';
                                  bool isChanged = false;

                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: const Text('Uredi komentar'),
                                            content: Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                controller: _controller,
                                                maxLines: 3,
                                                 autovalidateMode: AutovalidateMode.onUserInteraction,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Komentar',
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChanged = value.trim() !=
                                                        originalText.trim();
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Komentar ne može biti prazan';
                                                  }
                                                  if (value.isEmpty) {
                                                    return 'Komentar ne može biti prazan';
                                                  }

                                                  if (value.trim().isEmpty) {
                                                    return 'Komentar ne može imati samo razmake';
                                                  }

                                                  if (value.trim().length < 3) {
                                                    return 'Komentar mora imati najmanje 3 karaktera';
                                                  }

                                                  return null;
                                                },
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
                                                onPressed: (!isChanged ||
                                                        !_formKey.currentState!
                                                            .validate())
                                                    ? null
                                                    : () async {
                                                        try {
                                                          await _recenzijaProvider
                                                              .update(
                                                                  recenzija.id!,
                                                                  {
                                                                'tekst':
                                                                    _controller
                                                                        .text
                                                                        .trim(),
                                                              });

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                "Komentar uspješno ažuriran.",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                            ),
                                                          );
                                                          await _loadRecenzije();
                                                          Navigator.pop(
                                                              context);
                                                          // Opcionalno: osvježi ekran ako želiš odmah prikazati novu vrijednost
                                                        } on Exception catch (e) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
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
                                                            ),
                                                          );
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
                                  //setState(() {});
                                },
                              ),
                              IconButton(
                                tooltip: 'Izbrisi komentar',
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
                                      final komentarProvider =
                                          context.read<KomentarProvider>();
                                      await komentarProvider
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
                          Text(recenzija.tekst ?? "",
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(recenzija.datum),
                            style: const TextStyle(
                              //fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
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
