import 'dart:convert';

import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/screens/novostKomentar.dart';
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
  TextEditingController _naslovController = TextEditingController();
  TextEditingController _autorController = TextEditingController();
  String? _selectedStatus = "Sve";

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
                    constraints.maxWidth * 0.05, // Prostor između kolona
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
                      "Autor",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Slika",
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
                      //DataCell(Text(novost.naslov ?? "N/A")),
                       DataCell(
                        Text(_shortenText(
                            novost.naslov ?? '', 30)), // Skraćeni sadržaj
                      ),
                      DataCell(
                        Text(_shortenText(
                            novost.sadrzaj ?? '', 30)), // Skraćeni sadržaj
                      ),
                      DataCell(Text(DateFormat('dd.MM.yyyy.')
                          .format(novost.datumKreiranja ?? DateTime.now()))),
                      DataCell(Text(novost.autor?.korisnickoIme ?? "N/A")),
                      DataCell(Text(novost.status ?? "N/A")),
                      DataCell(
                        novost.slika != null && novost.slika!.isNotEmpty
                            ? Image.memory(
                                base64Decode(novost
                                    .slika!), // Pristupamo slici putem 'slika' unutar 'zaposlenik.slika'
                                width: 50, // Širina slike
                                height: 50, // Visina slike
                                fit: BoxFit.cover, // Prilagodba slike
                              )
                            : const Icon(Icons.account_circle,
                                size:
                                    50), // Ikona kao fallback ako slika nije dostupna
                      ),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Poravnavanje ikonica desno
                          children: [
                            IconButton(
                                icon: const Icon(Icons.comment),
                                tooltip: "Recenzije",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NovostKomentarPage(novost: novost),
                                    ),
                                  );
                                }),
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

                                // Akcija za update
                                print('Detalji clicked for: ${novost.naslov}');
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
                                    await _novostProvider.delete(novost.id!);
                                    setState(() {
                                      _novosti.remove(
                                          novost); // Uklonite obrisanu novost iz liste
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Novost uspješno obrisana.",
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
                                    print("greska prilikom brisanja novosti ${e.toString()}");
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
                            controller: _naslovController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po naslovu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _autorController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po autoru",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po statusu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            items: <String>["Sve", "Aktivna", "Neaktivna"]
                                .map((status) => DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        //const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _naslovController.clear();
                            _autorController.clear();
                            setState(() {
                              _selectedStatus = "Sve";
                            });
                          },
                          tooltip: 'Obriši unos',
                        ),
                        const SizedBox(width: 10),
                        /* IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _naslovController.clear();
                            _autorController.clear();
                            
                            setState(() {
                              _selectedStatus= "Sve"; 
                            });// Briše unos iz polja
                          },
                          tooltip: 'Obriši unos',
                        ),*/
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
                              var filter = {
                                'Naslov': _naslovController.text,
                                'Autor': _autorController.text,
                              };

                              // Ako je izabrana vrednost različita od "Sve", dodaj filter za status
                              if (_selectedStatus != null &&
                                  _selectedStatus != "Sve") {
                                filter['Status'] = _selectedStatus!;
                              }

                              var data =
                                  await _novostProvider.get(filter: filter);
                              setState(() {
                                _novosti = data.result;
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
