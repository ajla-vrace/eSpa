//import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/models/search_result.dart';
//import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/screens/novost_detalji.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NovostPage extends StatefulWidget {
  const NovostPage({super.key});

  @override
  _NovostiPageState createState() => _NovostiPageState();
}

class _NovostiPageState extends State<NovostPage> {
  List<Novost> _novosti = [];
  bool _isNovostLoading = true;
  SearchResult<Novost>? result;
  TextEditingController _ftsController = TextEditingController();
  late NovostProvider _novostProvider;

  String _shortenText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _novostProvider = context.read<NovostProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadNovosti();
  }

  Future<void> _loadNovosti() async {
    try {
      final novosti =
          await Provider.of<NovostProvider>(context, listen: false).get();
      setState(() {
        _novosti = novosti.result;
        _isNovostLoading = false;
      });
    } catch (e) {
      setState(() {
        _isNovostLoading = false;
      });
    }
  }

  Widget _buildNovostTable() {
    if (_isNovostLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_novosti.isEmpty) {
      return const Center(child: Text("Nema podataka"));
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% širine ekrana
      //height: MediaQuery.of(context).size.height * 0.65, // 50% visine ekrana
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
                /*headingRowColor: MaterialStateProperty.all(
                    Colors.lightBlue.shade100), // Boja zaglavlja
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.lightBlue.shade200; // Selektovani red
                    }
                    return Colors.white; // Podrazumevana boja reda
                  },
                ),*/
                headingRowColor: MaterialStateProperty.all(
                    Colors.green.shade800), // Tamnozelena boja za zaglavlje
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color.fromARGB(
                        255, 181, 226, 182); // Svetlozelena boja za redove
                  },
                ),
                columns: const [
                  /*DataColumn(
                    label: Text(
                      "ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),*/
                  DataColumn(
                    label: Text(
                      "Naslov",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Sadrzaj",
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
                rows: _novosti.map((novost) {
                  return DataRow(
                    cells: [
                      // DataCell(Text(novost.id?.toString() ?? "N/A")),
                      DataCell(Text(novost.naslov ?? "N/A")),
                      //DataCell(Text(novost.sadrzaj?.toString() ?? "N/A")),
                      DataCell(
                        Text(_shortenText(
                            novost.sadrzaj ?? '', 30)), // Skraćeni sadržaj
                      ),
                      DataCell(Text(DateFormat('dd.MM.yyyy.')
                          .format(novost.datum ?? DateTime.now()))),
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
                                        NovostDetaljiPage(novost: novost),
                                  ),
                                );
                                /* bool? isUpdated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NovostDetaljiPage(novost: novost),
                                  ),
                                );

                                // Provjera da li treba osvježiti podatke
                                if (isUpdated == true) {
                                  await _loadNovosti(); // Poziv metode za ponovno učitavanje podataka
                                  setState(() {});
                                }*/
                                // Akcija za update
                                print('Update clicked for: ${novost.naslov}');
                              },
                            ),
                            /* IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Akcija za delete
                                print('Delete clicked for: ${novost.naslov}');
                              },
                            ),*/

                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Potvrda brisanja"),
                                      content: const Text(
                                          "Da li ste sigurni da želite obrisati ovu novost?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Odustani"),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); // Korisnik je odustao
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Obriši"),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); // Korisnik je potvrdio
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  try {
                                    await _novostProvider.delete(novost.id!);
                                    setState(() {
                                      _novosti.remove(
                                          novost); // Uklonite obrisanu novost iz liste
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Novost uspešno obrisana.")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Došlo je do greške prilikom brisanja.")),
                                    );
                                  }
                                }
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
      title: ("Novosti"),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                /*const Text(
                  "Tabela Kategorije",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),*/
                //const SizedBox(height: 20), //const SizedBox(height: 20),
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
                              labelText: "Pretraži novosti",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        /*ElevatedButton(
                      onPressed: () {
                        final searchTerm = _ftsController.text;
                        print("Pretraženi termin: $searchTerm");
                        // Možete pozvati funkciju za pretragu ovde
                      },
                      child: const Text("Pretraži"),
                    ),*/
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
                            try {
                              var data = await _novostProvider
                                  .get(filter: {'fts': _ftsController.text});
                              setState(() {
                                _novosti =
                                    data.result; // Ažurirajte listu komentara
                              });
                              print(data.result);
                            } catch (e) {
                              print("Došlo je do greške prilikom pretrage: $e");
                              setState(() {
                                _novosti =
                                    []; // Prazna lista ako nema rezultata ili dođe do greške
                              });
                            }
                          },
                          child: const Text("Pretraži"),
                        ),
                        const SizedBox(width: 30),
                        /*ElevatedButton(
                          onPressed: () async {
                            
                            
                          },
                          child: const Text("Dodaj novu kategoriju"),
                        ),*/

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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NovostDetaljiPage(),
                              ),
                            );

                            // Dodaj funkcionalnost za dugme
                          },
                          child: Row(
                            /*mainAxisSize: MainAxisSize
                                .min, // Osigurava da Row zauzima minimalnu širinu potrebnu za ikonu i tekst*/
                            children: const [
                              Icon(Icons.add), // Ikonica plusa
                              SizedBox(
                                  width: 8), // Razmak između ikone i teksta
                              Text("Dodaj novu novost"), // Tekst dugmeta
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildNovostTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
