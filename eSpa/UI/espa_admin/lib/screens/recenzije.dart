import 'package:espa_admin/models/komentar.dart';
import 'package:espa_admin/models/ocjena.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/komentar_provider.dart';
import 'package:espa_admin/providers/ocjena_provider.dart';
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
  bool _isOcjenaLoading = true;
  SearchResult<Komentar>? result;
  TextEditingController _korisnikController = TextEditingController();
  TextEditingController _uslugaController = TextEditingController();

  late KomentarProvider _komentarProvider;
  late OcjenaProvider _ocjenaProvider;
  SearchResult<Ocjena>? result1;
  int? _selectedView = 0;
  List<Ocjena> _ocjene = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _komentarProvider = context.read<KomentarProvider>();
    _ocjenaProvider = context.read<OcjenaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadKomentari();
    _loadOcjene();
    loadProsjek();
  }

  Future<void> _loadKomentari() async {
    //print("u load komentari smo sada");
    try {
      //print("sada smo u try bloku");
      final komentari =
          await Provider.of<KomentarProvider>(context, listen: false).get();
      //print("komentari su ovdje $komentari");
      setState(() {
        //print("u loadkomentari komentari su $komentari");
        _komentari = komentari.result;
        _isKomentarLoading = false;
      });
    } catch (e) {
      setState(() {
        _isKomentarLoading = false;
      });
    }
  }

  Future<void> loadProsjek() async {
    // Čekaj da se podaci učitaju
    var nesto = await Provider.of<OcjenaProvider>(context, listen: false)
        .getUslugeProsjecneOcjene();

    // Ako je nesto lista, možeš proći kroz sve elemente i ispisati
    // ignore: unnecessary_type_check
    if (nesto is List) {
      for (var item in nesto) {
        print(
            "Usluga ID: ${item['uslugaId']}, Prosječna ocjena: ${item['prosjecnaOcjena']}");
      }
    } else {
      print("Podaci nisu u formatu liste");
    }
  }

  Future<void> _loadOcjene() async {
    //print("u load ocjene smo sada");
    try {
      //print("sada smo u try bloku");
      final ocjene =
          await Provider.of<OcjenaProvider>(context, listen: false).get();
      //print("komentari su ovdje $ocjene");
      setState(() {
        //print("u loadkomentari komentari su $ocjene");
        _ocjene = ocjene.result;
        _isOcjenaLoading = false;
      });
    } catch (e) {
      setState(() {
        _isOcjenaLoading = false;
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
                    constraints.maxWidth * 0.12, // Prostor između kolona
                headingRowColor: MaterialStateProperty.all(
                    Colors.green.shade800), // Tamnozelena boja za zaglavlje
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color.fromARGB(255, 181, 226, 182);
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
                      DataCell(
                        SizedBox(
                          width: 100, // ili neka druga širina u pikselima
                          child: Text(
                            komentar.korisnik!.korisnickoIme ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      //DataCell(Text(komentar.korisnik?.korisnickoIme ?? "N/A")),
                      //DataCell(Text(komentar.usluga?.naziv ?? "N/A")),
                      DataCell(
                        SizedBox(
                          width: 150, // ili neka druga širina u pikselima
                          child: Text(
                            komentar.usluga?.naziv ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150, // ili neka druga širina u pikselima
                          child: Text(
                            komentar.tekst ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),

                      //DataCell(Text(_shortenText(komentar.tekst ?? '', 30))),
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
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors
                                                  .grey, // Boja teksta na dugmetu (siva)
                                            ),
                                          ),
                                          TextButton(
                                            child: const Text("Obriši"),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors
                                                  .red, // Boja teksta na dugmetu (siva)
                                            ),
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

  Widget _buildOcjeneTable() {
    if (_isOcjenaLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_ocjene.isEmpty) {
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
                    constraints.maxWidth * 0.12, // Prostor između kolona
                headingRowColor: MaterialStateProperty.all(
                    Colors.green.shade800), // Tamnozelena boja za zaglavlje
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color.fromARGB(255, 181, 226, 182);
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
                      "Ocjena",
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
                rows: _ocjene.map((ocjena) {
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 100, // ili neka druga širina u pikselima
                          child: Text(
                            ocjena.korisnik!.korisnickoIme ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      //DataCell(Text(komentar.korisnik?.korisnickoIme ?? "N/A")),
                      DataCell(Text(ocjena.usluga?.naziv ?? "N/A")),
                      /*DataCell(
                        SizedBox(
                          width: 100, // ili neka druga širina u pikselima
                          child: Text(
                            ocjena.usluga?.naziv ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),*/
                      DataCell(
                        SizedBox(
                          width: 150, // ili neka druga širina u pikselima
                          child: Text(
                            ocjena.ocjena1.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),

                      //DataCell(Text(_shortenText(komentar.tekst ?? '', 30))),
                      DataCell(Text(DateFormat('dd.MM.yyyy.')
                          .format(ocjena.datum ?? DateTime.now()))),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                            "Da li ste sigurni da želite obrisati ovu ocjenu?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Odustani"),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors
                                                  .grey, // Boja teksta na dugmetu (siva)
                                            ),
                                          ),
                                          TextButton(
                                            child: const Text("Obriši"),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors
                                                  .red, // Boja teksta na dugmetu (siva)
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    try {
                                      await _ocjenaProvider.delete(ocjena.id!);
                                      setState(() {
                                        _ocjene.remove(
                                            ocjena); // Uklonite obrisanu novost iz liste
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
                        const SizedBox(width: 10),
                        /*IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _korisnikController.clear();
                            _uslugaController.clear();
                          },
                          tooltip: 'Obriši unos',
                        ),*/
                         (_korisnikController.text.isNotEmpty ||
                                _uslugaController.text.isNotEmpty )
                            ? IconButton(
                                icon: Icon(Icons.backspace, color: Colors.red),
                                onPressed: () {
                                  _korisnikController.clear();
                                  _uslugaController.clear();

                                },
                                tooltip: 'Obriši unos',
                              )
                            : SizedBox.shrink(),
                        const SizedBox(width: 10),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            minimumSize: const Size(120, 50),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            var filter = {
                              'Korisnik': _korisnikController.text,
                              'Usluga': _uslugaController.text,
                            };

                            try {
                              if (_selectedView == 0) {
                                // Pretraga komentara
                                var data =
                                    await _komentarProvider.get(filter: filter);
                                setState(() {
                                  _komentari = data.result;
                                });
                              } else if (_selectedView == 1) {
                                // Pretraga ocjena
                                var data =
                                    await _ocjenaProvider.get(filter: filter);
                                print(
                                    "DATA------------------------------------->$data");
                                var nesto = await _ocjenaProvider
                                    .getUslugeProsjecneOcjene();
                                print(
                                    "NESTO ----------------------------------------> : $nesto");
                                setState(() {
                                  _ocjene = data.result;
                                });
                              }
                            } catch (e) {
                              print("Greška prilikom pretrage: $e");
                              setState(() {
                                if (_selectedView == 0) {
                                  _komentari = [];
                                } else if (_selectedView == 1) {
                                  _ocjene = [];
                                }
                              });
                            }
                          },
                          child: const Text("Pretraži"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _selectedView = 0;
                        });
                        _korisnikController.clear();
                        _uslugaController.clear();
                        // Učitaj sve komentare
                        var data = await _komentarProvider.get();
                        setState(() {
                          _komentari = data.result;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        backgroundColor: _selectedView == 0
                            ? Colors.green
                            : Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Recenzije usluga",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _selectedView = 1;
                        });
                        _korisnikController.clear();
                        _uslugaController.clear();
                        // Učitaj sve ocjene
                        var data = await _ocjenaProvider.get();
                        setState(() {
                          _ocjene = data.result;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        backgroundColor: _selectedView == 1
                            ? const Color.fromARGB(255, 47, 105, 48)
                            : Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Ocjene usluga",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                if (_selectedView == 0) _buildKomentariTable(),
                if (_selectedView == 1) _buildOcjeneTable(),
                //_buildKomentariTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
