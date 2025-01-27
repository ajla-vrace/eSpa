import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KategorijaPage extends StatefulWidget {
  const KategorijaPage({super.key});

  @override
  _KategorijaPageState createState() => _KategorijaPageState();
}

class _KategorijaPageState extends State<KategorijaPage> {
  List<Kategorija> _kategorije = [];
  bool _isKategorijaLoading = true;
  SearchResult<Kategorija>? result;
  TextEditingController _ftsController = TextEditingController();
  late KategorijaProvider _kategorijaProvider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _kategorijaProvider = context.read<KategorijaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadKategorije();
  }

  Future<void> _loadKategorije() async {
    try {
      final kategorije =
          await Provider.of<KategorijaProvider>(context, listen: false).get();
      setState(() {
        _kategorije = kategorije.result;
        _isKategorijaLoading = false;
      });
    } catch (e) {
      setState(() {
        _isKategorijaLoading = false;
      });
    }
  }

  Widget _buildKategorijeTable() {
    if (_isKategorijaLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kategorije.isEmpty) {
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
                  DataColumn(
                    label: Text(
                      "ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Naziv",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: _kategorije.map((kategorija) {
                  return DataRow(
                    cells: [
                      DataCell(Text(kategorija.id?.toString() ?? "N/A")),
                      DataCell(Text(kategorija.naziv ?? "N/A")),
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
      title: ("Kategorije"),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Tabela Kategorije",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20), //const SizedBox(height: 20),
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
                              labelText: "Pretraži kategorije",
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
                          onPressed: () async {
                            try {
                              var data = await _kategorijaProvider
                                  .get(filter: {'fts': _ftsController.text});
                              setState(() {
                                _kategorije =
                                    data.result; // Ažurirajte listu komentara
                              });
                            } catch (e) {
                              print("Došlo je do greške prilikom pretrage: $e");
                              setState(() {
                                _kategorije =
                                    []; // Prazna lista ako nema rezultata ili dođe do greške
                              });
                            }
                          },
                          child: const Text("Pretraži"),
                        ),
                        const SizedBox(width: 10),
                        /*ElevatedButton(
                          onPressed: () async {
                            
                            
                          },
                          child: const Text("Dodaj novu kategoriju"),
                        ),*/

                        ElevatedButton(
                          onPressed: () async {
                            // Dodaj funkcionalnost za dugme
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Osigurava da Row zauzima minimalnu širinu potrebnu za ikonu i tekst
                            children: const [
                              Icon(Icons.add), // Ikonica plusa
                              SizedBox(
                                  width: 8), // Razmak između ikone i teksta
                              Text("Dodaj novu kategoriju"), // Tekst dugmeta
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildKategorijeTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
