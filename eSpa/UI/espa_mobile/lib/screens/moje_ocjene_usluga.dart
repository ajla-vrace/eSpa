import 'package:espa_mobile/models/ocjena.dart';
import 'package:espa_mobile/providers/ocjena_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:espa_mobile/utils/util.dart';

class MojeOcjeneScreen extends StatefulWidget {
  const MojeOcjeneScreen({super.key});

  @override
  State<MojeOcjeneScreen> createState() => _MojeOcjeneScreenState();
}

class _MojeOcjeneScreenState extends State<MojeOcjeneScreen> {
  List<Ocjena> ocjene = [];
  bool isLoading = true;
  int brojOcjena = 0;
  late OcjenaProvider _ocjenaProvider;

  String formatDate(DateTime? date) {
    if (date == null) return "Nepoznato";
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}.";
  }

  @override
  void initState() {
    super.initState();
    _loadOcjene();
  }

  Future<void> _loadOcjene() async {
    final korisnickoIme = await getUserName();
    if (korisnickoIme != null) {
      _ocjenaProvider = context.read<OcjenaProvider>();
      final data = await _ocjenaProvider.get(filter: {
        'korisnik': korisnickoIme,
      });

      setState(() {
        ocjene = data.result;
        brojOcjena = data.count;
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
      title: "Moje ocjene usluga",
      selectedIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Moje ocjene usluga',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Ukupno ocjena: $brojOcjena',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (ocjene.isEmpty)
              const Center(
                child: Text(
                  "Nemate nijednu ocjenu usluga.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            // const Text("Nemate nijednu recenziju.")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ocjene.length,
                itemBuilder: (context, index) {
                  final ocjena = ocjene[index];
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
                                  ocjena.usluga!.naziv ?? "Nepoznata usluga",
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
                                      ocjena.ocjena1!.toDouble();
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: const Text('Uredi ocjenu'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                               /* buildStars(
                                                    currentRating),*/ // Prikaz trenutnih zvjezdica
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children:
                                                      List.generate(5, (index) {
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
                                                            : Icons.star_border,
                                                        color: Colors.yellow,
                                                        size: 32,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
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
                                                  try {
                                                    await _ocjenaProvider
                                                        .update(ocjena.id!, {
                                                      'ocjena1':
                                                          currentRating.round(),
                                                    });

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Ocjena uspješno ažurirana."),
                                                        backgroundColor:
                                                            Colors.green,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        duration: Duration(
                                                            seconds: 3),
                                                      ),
                                                    );
                                                    await _loadOcjene();
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
                                                              child: const Text(
                                                                  "OK"),
                                                            ),
                                                          ],
                                                        );
                                                      },
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
                                },
                              ),
                              IconButton(
                                tooltip: 'Izbriši ocjenu',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Potvrda brisanja"),
                                        content: const Text(
                                            "Da li ste sigurni da želite obrisati ovu ocjenu?"),
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
                                      await _ocjenaProvider.delete(ocjena.id!);

                                      setState(() {
                                        ocjene.remove(ocjena);
                                        brojOcjena = ocjene.length;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Ocjena uspješno obrisana.",
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
                                              "Greška prilikom brisanja ocjene."),
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
                          buildStars(ocjena.ocjena1!
                              .toDouble()), // Prikaz zvjezdica ocjene
                          const SizedBox(height: 4),
                          Text(
                            formatDate(ocjena.datum),
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
