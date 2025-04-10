import 'package:espa_admin/models/komentar.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/komentar_provider.dart';
import 'package:espa_admin/screens/recenzija_detalji.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecenzijaPage extends StatefulWidget {
  const RecenzijaPage({super.key});

  @override
  _RecenzijaPageState createState() => _RecenzijaPageState();
}

class _RecenzijaPageState extends State<RecenzijaPage> {
  List<Komentar> _komentari = [];
  bool _isKomentarLoading = true;
  SearchResult<Komentar>? result;
  TextEditingController _korisnikController = TextEditingController();
  TextEditingController _uslugaController = TextEditingController();

  late KomentarProvider _komentarProvider;

  String _shortenText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _komentarProvider = context.read<KomentarProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadKomentari();
  }

  Future<void> _loadKomentari() async {
    print("u load komentari smo sada");
    try {
      print("sada smo u try bloku");
      final komentari =
          await Provider.of<KomentarProvider>(context, listen: false).get();
      print("komentari su ovdje $komentari");
      setState(() {
        print("u loadkomentari komentari su $komentari");
        _komentari = komentari.result;
        _isKomentarLoading = false;
      });
    } catch (e) {
      setState(() {
        _isKomentarLoading = false;
      });
    }
  }

  Widget _buildKomentariTable() {
    if (_isKomentarLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_komentari.isEmpty) {
      return const Center(child: Text("Nema podataka"));
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% širine ekrana
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Okvir oko tabele
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: constraints.maxWidth, // Tabela zauzima maksimalnu širinu
              child: DataTable(
                columnSpacing:
                    constraints.maxWidth * 0.16, // Prostor između kolona
                headingRowColor: MaterialStateProperty.all(
                    Colors.green.shade800), // Tamnozelena boja za zaglavlje
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color.fromARGB(
                        255, 181, 226, 182); // Svetlozelena boja za redove
                  },
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      "Korisnik",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Usluga",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Tekst",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Datum",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: _komentari.map((komentar) {
                  return DataRow(
                    cells: [
                      DataCell(Text(komentar.korisnik?.korisnickoIme ?? "N/A")),
                      DataCell(Text(komentar.usluga?.naziv ?? "N/A")),
                      DataCell(Text(_shortenText(komentar.tekst ?? '', 30))),
                      DataCell(Text(DateFormat('dd.MM.yyyy.')
                          .format(komentar.datum ?? DateTime.now()))),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  // Akcija za update
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecenzijaDetaljiPage(
                                              komentar: komentar),
                                    ),
                                  );
                                  print(
                                      'Update clicked for: ${komentar.tekst}');
                                },
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: const Icon(Icons.delete),
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
                                          ),
                                          TextButton(
                                            child: const Text("Obriši"),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    try {
                                      await _komentarProvider
                                          .delete(komentar.id!);
                                      setState(() {
                                        _komentari.remove(
                                            komentar); // Uklonite obrisanu novost iz liste
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
                                          backgroundColor: Colors
                                              .green, // Dodaj zelenu pozadinu
                                          behavior: SnackBarBehavior
                                              .floating, // Opcionalno za lepši prikaz
                                          duration: Duration(seconds: 3),
                                          /*margin: EdgeInsets.symmetric(
                                            horizontal: 100.0, vertical: 20.0),
                                        padding: EdgeInsets.all(8.0),*/
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Došlo je do greške prilikom brisanja.")),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Recenzije"),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Ograničavanje širine
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _korisnikController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po korisničkom imenu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _uslugaController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po nazivu usluge",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        /*  IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _korisnikController.clear();
                            _uslugaController.clear();
                            
                          },
                          tooltip: 'Obriši unos',
                        ),*/
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            minimumSize: const Size(120, 50),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            try {
                              var filter = {
                                'Korisnik': _korisnikController.text,
                                'Usluga': _uslugaController.text,
                              };
                              print("filter je ovdje $filter");
                              //var data = await _komentarProvider.get();
                              var data = await _komentarProvider.get(filter: filter);
                              print("data je ovdje: ${data.result}");
                              setState(() {
                                _komentari =
                                    data.result; // Ažuriraj listu komentara
                              });
                            } catch (e) {
                              print("Došlo je do greške prilikom pretrage: $e");
                              setState(() {
                                _komentari =
                                    []; // Prazna lista ako nema rezultata ili dođe do greške
                              });
                            }
                          },
                          child: const Text("Pretraži"),
                        ),
                        //const SizedBox(width: 30),
                        /*ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            minimumSize: const Size(120, 50),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KategorijaDetaljiPage(),
                              ),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.add),
                              SizedBox(width: 8),
                              Text("Dodaj novu kategoriju"),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildKomentariTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
