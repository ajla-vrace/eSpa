import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/termin.dart';
import 'package:espa_admin/providers/termin_provider.dart';
import 'package:espa_admin/screens/termin_detalji.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TerminPage extends StatefulWidget {
  const TerminPage({super.key});

  @override
  _TerminPageState createState() => _TerminPageState();
}

class _TerminPageState extends State<TerminPage> {
  List<Termin> _termini = [];
  bool _isTerminLoading = true;
  SearchResult<Termin>? result;
  TextEditingController _ftsController = TextEditingController();
  late TerminProvider _terminProvider;

  String formatTime(String timeString) {
    try {
      DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return timeString; // Ako dođe do greške u parsiranju, vratite originalni string
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _terminProvider = context.read<TerminProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadTermine();
  }

  Future<void> _loadTermine() async {
    try {
      final termini =
          await Provider.of<TerminProvider>(context, listen: false).get();
      setState(() {
        _termini = termini.result;
        _isTerminLoading = false;
      });
    } catch (e) {
      setState(() {
        _isTerminLoading = false;
      });
    }
  }

  Widget _buildTerminiTable() {
    if (_isTerminLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_termini.isEmpty) {
      return const Center(child: Text("Nema podataka"));
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% širine ekrana
      //height: MediaQuery.of(context).size.height * 0.5, // 50% visine ekrana
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Okvir oko tabele
        //borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: constraints.maxWidth, // Tabela zauzima maksimalnu širinu
              child: DataTable(
                columnSpacing:
                    constraints.maxWidth * 0.2, // Prostor između kolona

                headingRowColor: MaterialStateProperty.all(
                    Colors.green.shade800), // Tamnozelena boja za zaglavlje
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color.fromARGB(
                        255, 181, 226, 182); // Svetlozelena boja za redove
                  },
                ),
                columns: const [
                  /* DataColumn(
                    label: Text(
                      "ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),*/
                  DataColumn(
                    label: Text(
                      "Početak termina",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Kraj termina",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  /*DataColumn(
                    label: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),*/
                ],
                rows: _termini.map((termin) {
                  return DataRow(
                    cells: [
                      //DataCell(Text(kategorija.id?.toString() ?? "N/A")),
                      //DataCell(Text(termin.pocetak ?? "N/A")),
                      //DataCell(Text(termin.kraj ?? "N/A")),
                      DataCell(Text(formatTime(termin.pocetak ?? "00:00:00"))),
                      DataCell(Text(formatTime(termin.kraj ?? "00:00:00"))),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Poravnavanje ikonica desno
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TerminDetaljiPage(termin: termin),
                                  ),
                                );
                                // Akcija za update
                                print('Update clicked for: ${termin.pocetak}');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Potvrda brisanja"),
                                      content: const Text(
                                          "Da li ste sigurni da želite obrisati ovaj termin?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Odustani"),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); // Korisnik je odustao
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors
                                                .grey, // Boja teksta na dugmetu (siva)
                                          ),
                                        ),
                                        TextButton(
                                          child: const Text("Obriši"),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); // Korisnik je potvrdio
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
                                    await _terminProvider.delete(termin.id!);
                                    setState(() {
                                      _termini.remove(
                                          termin); // Uklonite obrisanu novost iz liste
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Termin uspješno obrisan.",
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Došlo je do greške prilikom brisanja.")),
                                    );
                                  }
                                }

                                // Akcija za delete
                                print('Delete clicked for: ${termin.pocetak}');
                              },
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
      title: ("Termini"),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Novi red za input i dugme
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Ograničavanje širine
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ftsController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži termine po početnom vremenu",
                              hintText: "Format HH:mm (npr. 09:00)",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        /*(_ftsController.text.isNotEmpty)
                            ? IconButton(
                                icon: Icon(Icons.backspace, color: Colors.red),
                                onPressed: () {
                                  _ftsController.clear();
                                },
                                tooltip: 'Obriši unos',
                              )
                            : SizedBox.shrink(),*/
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0), // Isti padding za oba dugmeta
                            minimumSize: const Size(
                                120, 50), // Ista minimalna širina i visina
                            textStyle: const TextStyle(fontSize: 16),
                          ), // Ista veličina fonta

                          onPressed: () async {
                            //final searchTerm = _ftsController.text;
                            final searchTerm = _ftsController.text.trim();

                            // Regularni izraz za tačan format HH:mm (bez sekundi ili dodatnih karaktera)
                            RegExp validFormat = RegExp(r'^\d{2}:\d{2}$');
                            RegExp invalidFormat = RegExp(
                                r'^\d{2}:\d{2}:'); // Hvata 09:00: ili 09:00:00

                            if (searchTerm.isEmpty) {
                              try {
                                var data = await _terminProvider
                                    .get(); // Dohvati sve termine ako je input prazan
                                setState(() {
                                  _termini = data.result;
                                });
                              } catch (e) {
                                print(
                                    "Došlo je do greške prilikom učitavanja svih termina: $e");
                                setState(() {
                                  _termini = [];
                                });
                              }
                            } else if (invalidFormat.hasMatch(searchTerm) ||
                                !validFormat.hasMatch(searchTerm)) {
                              // Ako format nije validan, jednostavno obriši tabelu
                              setState(() {
                                _termini = [];
                              });
                            } else if (!validFormat.hasMatch(searchTerm)) {
                              // Ako format nije ispravan (npr. tekstualni unos), takođe prikaži poruku
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Format mora biti HH:mm (npr. 09:00)."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // Ako je format tačan (HH:mm), izvrši pretragu
                              try {
                                var data = await _terminProvider
                                    .get(filter: {'pocetak': searchTerm});
                                setState(() {
                                  _termini = data.result;
                                });

                                if (_termini.isEmpty) {}
                              } catch (e) {
                                print(
                                    "Došlo je do greške prilikom pretrage: $e");
                                setState(() {
                                  _termini = [];
                                });
                              }
                            }
                          },
                          child: const Text("Pretraži"),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0), // Isti padding za oba dugmeta
                            minimumSize: const Size(
                                120, 50), // Ista minimalna širina i visina
                            textStyle: const TextStyle(
                                fontSize: 16), // Ista veličina fonta
                          ),
                          onPressed: () async {
                            // Dodaj funkcionalnost za dugme
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TerminDetaljiPage(),
                              ),
                            );
                          },
                          child: Row(
                            /*mainAxisSize: MainAxisSize
                                .min, // Osigurava da Row zauzima minimalnu širinu potrebnu za ikonu i tekst*/
                            children: const [
                              Icon(Icons.add), // Ikonica plusa
                              SizedBox(
                                  width: 8), // Razmak između ikone i teksta
                              Text("Dodaj novi termin"), // Tekst dugmeta
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTerminiTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
