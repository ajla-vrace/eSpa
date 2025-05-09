//import 'package:espa_admin/models/kategorija.dart';
//import 'package:espa_admin/models/novost.dart';
import 'dart:convert';

import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/usluga.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
//import 'package:espa_admin/providers/kategorija_provider.dart';
//import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
//import 'package:espa_admin/screens/novost_detalji.dart';
import 'package:espa_admin/screens/usluga_detalji.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UslugaPage extends StatefulWidget {
  const UslugaPage({super.key});

  @override
  _UslugePageState createState() => _UslugePageState();
}

class _UslugePageState extends State<UslugaPage> {
  List<Usluga> _usluge = [];
  bool _isUslugaLoading = true;
  SearchResult<Usluga>? result;
  //TextEditingController _ftsController = TextEditingController();
  TextEditingController _nazivController = TextEditingController();
  TextEditingController _cijenaController = TextEditingController();
  TextEditingController _trajanjeController = TextEditingController();
  late UslugaProvider _uslugaProvider;
  //late KategorijaProvider _kategorijaProvider;

  String? selectedKategorija = "Sve";

  List<Kategorija>? kategorije;

  List<String?>? _kategorije; // Varijabla za pohranu odabrane kategorije
  //List<String> kategorije = [];

  //List<Kategorija>? _kategorije;

  //var kategorije;

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
    _uslugaProvider = context.read<UslugaProvider>();
    // _kategorijaProvider = context.read<KategorijaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadUsluge();
    _loadKategorije();
  }

  Future<void> _loadUsluge() async {
    try {
      final usluge =
          await Provider.of<UslugaProvider>(context, listen: false).get();
      setState(() {
        _usluge = usluge.result;
        _isUslugaLoading = false;
      });
    } catch (e) {
      setState(() {
        _isUslugaLoading = false;
      });
    }
  }

  Widget _buildUslugaTable() {
    if (_isUslugaLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_usluge.isEmpty) {
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
                columnSpacing: 15,
                //OVDJE JE  // constraints.maxWidth * 0.2, // Prostor između kolona
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
                      "Naziv",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Opis",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Cijena",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Trajanje",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Kategorija",
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
                rows: _usluge.map((usluga) {
                  return DataRow(
                    cells: [
                      // DataCell(Text(novost.id?.toString() ?? "N/A")),
                      // DataCell(Text(usluga.naziv ?? "N/A")),
                      DataCell(
                        Text(_shortenText(
                            usluga.naziv ?? '', 30)), // Skraćeni sadržaj
                      ),
                      //DataCell(Text(novost.sadrzaj?.toString() ?? "N/A")),
                      DataCell(
                        Text(_shortenText(
                            usluga.opis ?? '', 30)), // Skraćeni sadržaj
                      ),
                      //DataCell(Text(usluga.cijena?.toStringAsFixed(2) ?? "N/A")),
                      DataCell(Text(
                          '${usluga.cijena?.toStringAsFixed(0) ?? "N/A"} KM')),
                      //DataCell(Text(usluga.trajanje ?? "N/A")),
                      DataCell(Text('${usluga.trajanje ?? "N/A"} min')),
                      DataCell(Text(usluga.kategorija!.naziv ?? "N/A")),
                      DataCell(
                        usluga.slika != null && usluga.slika!.isNotEmpty
                            ? Image.memory(
                                base64Decode(usluga
                                    .slika!), // Pristupamo slici putem 'slika' unutar 'zaposlenik.slika'
                                width: 50, // Širina slike
                                height: 50, // Visina slike
                                fit: BoxFit.cover, // Prilagodba slike
                              )
                            : const Icon(Icons.image_not_supported,
                                size:
                                    50), // Ikona kao fallback ako slika nije dostupna
                      ),
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
                                        UslugaDetaljiPage(usluga: usluga),
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
                                print('Update clicked for: ${usluga.naziv}');
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
                                          "Da li ste sigurni da želite obrisati ovu uslugu?"),
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
                                    await _uslugaProvider.delete(usluga.id!);
                                    setState(() {
                                      _usluge.remove(
                                          usluga); // Uklonite obrisanu uslugu iz liste
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Usluga uspješno obrisana.",
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

  /* Future<void> _loadKategorije1() async {
    final kategorijeSve =
        await Provider.of<KategorijaProvider>(context, listen: false).get();
    setState(() {
      _kategorije = kategorijeSve.result;
      selectedKategorija = _kategorije!.isNotEmpty
          ? _kategorije![0].naziv
          : null; // Postavi početni odabir

      //_isUslugaLoading = false;
    });
  }*/

  Future<void> _loadKategorije() async {
    final kategorijeSve =
        await Provider.of<KategorijaProvider>(context, listen: false).get();
    kategorije = kategorijeSve.result;
    print("kategorije: $kategorije");
    /* setState(() {
    // Mapiraj kategorije i uzmi samo nazive
    _kategorije = kategorije
        ?.map((kategorija) => kategorija.naziv) // Uzimamo samo naziv
        .toList(); // Ovo vraća listu samo sa nazivima kategorija
        print("_kategorije je sada $_kategorije");
  });*/
    setState(() {
      // Mapiraj kategorije i uzmi samo nazive
      _kategorije = [
        "Sve",
        ...kategorije?.map((kategorija) => kategorija.naziv).toList() ?? []
      ];
    });
  }

/*
  DropdownButton<String?> buildKategorijaDropdown() {
    return DropdownButton<String?>(
      value: selectedKategorija, // Trenutno odabrana kategorija
      onChanged: (String? newValue) {
        setState(() {
          selectedKategorija = newValue;
          // Ako trebaš filtrirati usluge po kategoriji, ovde možeš pozvati funkciju za filtriranje
          //_loadUsluge();  // Ovde možeš dodati funkciju koja filtrira usluge po kategoriji
        });
      },
      items: ["Sve", ..._kategorije!.map((kategorija) => kategorija.naziv)]
          .map<DropdownMenuItem<String?>>((String? value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Text(value ??
              "Nema kategorije"), // Ako je value null, prikaži tekst "Nema kategorije"
        );
      }).toList(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Usluge"),
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
                            controller: _nazivController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po nazivu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cijenaController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po cijeni",
                              hintText: "Format: 100 (bez valute)",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _trajanjeController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po trajanju",
                              hintText: "Format: 100 (bez min)",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            value: selectedKategorija,
                            decoration: const InputDecoration(
                              labelText: "Pretrazi po kategoriji",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.filter_list),
                            ),
                            items: _kategorije?.map((naziv) {
                              return DropdownMenuItem<String>(
                                value: naziv, // Koristi samo naziv kategorije
                                child:
                                    Text(naziv!), // Prikazuje naziv kategorije
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedKategorija = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _nazivController.clear();
                            _cijenaController.clear();
                            _trajanjeController.clear();
                            setState(() {
                              selectedKategorija = "Sve";
                            }); // Briše unos iz polja
                          },
                          tooltip: 'Obriši unos',
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
                              var filter = {
                                'Naziv': _nazivController.text,
                                'Cijena': _cijenaController.text,
                                'Trajanje': _trajanjeController.text,
                                //'Uloga': selectedUloga == "Sve" ? null : selectedUloga,
                                /*'Status':
                                    _selectedStatus, */ // Dodajemo status u filter
                              };
                              if (selectedKategorija != "Sve") {
                                filter['Kategorija'] = selectedKategorija!;
                              }
                              var data =
                                  await _uslugaProvider.get(filter: filter);
                              setState(() {
                                _usluge =
                                    data.result; // Ažurirajte listu komentara
                              });
                            } catch (e) {
                              print("Došlo je do greške prilikom pretrage: $e");
                              setState(() {
                                _usluge =
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
                                builder: (context) => UslugaDetaljiPage(),
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
                              Text("Dodaj novu uslugu"), // Tekst dugmeta
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildUslugaTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
