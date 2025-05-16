import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/screens/kategorija_detalji.dart';
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

  Widget _buildKategorijaTable() {
    if (_isKategorijaLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kategorije.isEmpty) {
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
                    constraints.maxWidth * 0.1, // Prostor između kolona
                
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
                      "Naslov",
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
                rows: _kategorije.map((kategorija) {
                  return DataRow(
                    cells: [
                      // DataCell(Text(novost.id?.toString() ?? "N/A")),
                      DataCell(Text(kategorija.naziv ?? "N/A")),
                      //DataCell(Text(novost.sadrzaj?.toString() ?? "N/A")),
                      
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
                                        KategorijaDetaljiPage(kategorija: kategorija),
                                  ),
                                );
                               
                                // Akcija za update
                                print('Detalji clicked for: ${kategorija.naziv}');
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
                                          "Da li ste sigurni da želite obrisati ovu novost?"),
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
                                    await _kategorijaProvider.delete(kategorija.id!);
                                    setState(() {
                                      _kategorije.remove(
                                          kategorija); // Uklonite obrisanu novost iz liste
                                    });
                                   
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Kategorija uspješno obrisana.",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: Colors
                                            .green, // Dodaj zelenu pozadinu
                                        behavior: SnackBarBehavior
                                            .floating, // Opcionalno za lepši prikaz
                                        duration: Duration(seconds: 3),
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
      title: ("Kategorije"),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
               
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
                              labelText: "Pretraži po nazivu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                       const SizedBox(width: 10),
                       /* IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _ftsController.clear();
                          },
                          tooltip: 'Obriši unos',
                        ),*/
                         (_ftsController.text.isNotEmpty )
                            ? IconButton(
                                icon: Icon(Icons.backspace, color: Colors.red),
                                onPressed: () {
                                  _ftsController.clear();
                                },
                                tooltip: 'Obriši unos',
                              )
                            : SizedBox.shrink(),
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
                            try {
                              var data = await _kategorijaProvider.get(filter: {
                                'fts': _ftsController.text,
                                //'Autor': _autorController.text,
                                //'Status': _statusController.text
                                //'Status': _selectedStatus ?? ""
                              });
                              setState(() {
                                _kategorije =
                                    data.result; // Ažurirajte listu komentara
                              });
                              print(data.result);
                             
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KategorijaDetaljiPage(),
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
                              Text("Dodaj novu kategoriju"), // Tekst dugmeta
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildKategorijaTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
