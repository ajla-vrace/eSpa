import 'dart:convert';

import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/uloga.dart';
import 'package:espa_admin/models/zaposlenik.dart';
import 'package:espa_admin/providers/uloga_provider.dart';
//import 'package:espa_admin/providers/zaposlenikSlike_provider.dart';
import 'package:espa_admin/providers/zaposlenik_provider.dart';
import 'package:espa_admin/screens/zaposlenikRecenzije.dart';
import 'package:espa_admin/screens/zaposlenik_detalji.dart';
import 'package:espa_admin/screens/zaposlenik_edit.dart';
import 'package:espa_admin/screens/zaposlenik_info.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZaposlenikPage extends StatefulWidget {
  const ZaposlenikPage({super.key});

  @override
  _ZaposlenikPageState createState() => _ZaposlenikPageState();
}

class _ZaposlenikPageState extends State<ZaposlenikPage> {
  List<Zaposlenik> _zaposlenici = [];
  bool _isZaposleniciLoading = true;
  SearchResult<Zaposlenik>? result;
  //TextEditingController _ftsController = TextEditingController();
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  TextEditingController _korisnickoImeController = TextEditingController();
  late ZaposlenikProvider _zaposlenikProvider;
  late UlogaProvider _ulogaProvider;
  //late ZaposlenikSlikeProvider _zaposlenikSlikeProvider;
  String selectedUloga = "Sve";

  List<String>? ulogeOption;
  /*String _shortenText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }*/

  DropdownButton<String> buildUlogaDropdown(List<String> uloge) {
    return DropdownButton<String>(
      value: selectedUloga,
      onChanged: (String? newValue) {
        setState(() {
          selectedUloga = newValue!;
          _loadZaposlenici(); // Ponovno učitajte zaposlenike s filtriranim rezultatima
        });
      },
      items: ["Sve", ...uloge].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _loadUloge();
    //_zaposlenikSlikeProvider = context.read<ZaposlenikSlikeProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadZaposlenici();
  }

  Future<void> _loadUloge() async {
    try {
      // Pretpostavljam da imaš metodu za dohvat svih uloga, pa pozivamo tu metodu.
      var uloge = await _ulogaProvider.get();
      List<Uloga> ulogeList = uloge.result;
      // Dodajemo "Sve" kao prvu opciju
      setState(() {
        ulogeOption = ["Sve"] +
            ulogeList.map((u) => u.naziv!).toList(); // `naziv` je naziv uloge
      });
    } catch (e) {
      print("Greška pri učitavanju uloga: $e");
    }
  }

  Future<void> _loadZaposlenici() async {
    try {
      final zaposlenici =
          await Provider.of<ZaposlenikProvider>(context, listen: false).get();

      setState(() {
        _zaposlenici = zaposlenici.result;
        _isZaposleniciLoading = false;
      });
      print("broj zaposlenika: ${zaposlenici.count}");
      print("broj _zaposlenika: ${_zaposlenici.length}");
      print("_zaposleniic $_zaposlenici");
      for (var zaposlenik in _zaposlenici) {
        print("Korisnik: ${zaposlenik.korisnik}");
        print("KorisnikUloge: ${zaposlenik.korisnik?.korisnikUlogas}");

        // Proveri da li lista korisnikUlogas nije prazna
        if (zaposlenik.korisnik?.korisnikUlogas.isNotEmpty ?? false) {
          print(
              "Prva uloga: ${zaposlenik.korisnik?.korisnikUlogas.first.uloga?.naziv ?? "Nema naziva uloge"}");
        } else {
          print("Nema uloge");
        }
      }
    } catch (e) {
      setState(() {
        _isZaposleniciLoading = false;
      });
    }
  }

  Widget _buildZaposlenikTable() {
    if (_isZaposleniciLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_zaposlenici.isEmpty) {
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
                      "Korisnicko ime",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Ime",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Prezime",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  /*DataColumn(
                    label: Text(
                      "DatumZaposlenja",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),*/
                  DataColumn(
                    label: Text(
                      "Kategorija",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Uloga",
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
                rows: _zaposlenici.reversed.map((zaposlenik) {
                  return DataRow(
                    cells: [
                      // DataCell(Text(novost.id?.toString() ?? "N/A")),
                      DataCell(
                          Text(zaposlenik.korisnik?.korisnickoIme ?? "N/A")),
                      //DataCell(Text(novost.sadrzaj?.toString() ?? "N/A")),
                      DataCell(Text(zaposlenik.korisnik?.ime ?? "N/A")),
                      DataCell(Text(zaposlenik.korisnik?.prezime ?? "N/A")),
                      //DataCell(Text(DateFormat('dd.MM.yyyy.').format(
                      //zaposlenik.datumZaposlenja ?? DateTime.now()))),
                      //DataCell(Text(zaposlenik.struka ?? "N/A")),
                      DataCell(
                        SizedBox(
                          width: 100, // prilagodi po potrebi
                          child: Text(
                            zaposlenik.kategorija!.naziv ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),

                      // DataCell(Text(zaposlenik.korisnik?.korisnikUlogas.first.uloga!.naziv ?? "N/A")),
                      DataCell(
                        Text(
                          zaposlenik.korisnik?.korisnikUlogas.isNotEmpty == true
                              ? zaposlenik.korisnik!.korisnikUlogas.first.uloga
                                      ?.naziv ??
                                  "N/A"
                              : "Nema ulogu",
                        ),
                      ),

                      //DataCell(Text(zaposlenik.status ?? "N/A")),
                      /* DataCell(
                        zaposlenik.slika?.slika != null /*&& zaposlenik.slika.slika.isNotEmpty*/
                            ? Image.memory(
                                // Ako slika dolazi kao byte[] iz baze podataka
                                zaposlenik.slika.slika,
                                width: 50, // Širina slike
                                height: 50, // Visina slike
                                fit: BoxFit.cover, // Prilagodba slike
                              )
                            : const Icon(Icons.account_circle,
                                size:
                                    50), // Ikona kao fallback ako slika nije dostupna
                      ),*/
                     /* DataCell(
                        zaposlenik.slika?.slika != null
                            ? Image.memory(
                                base64Decode(zaposlenik.slika!
                                    .slika!), // Pristupamo slici putem 'slika' unutar 'zaposlenik.slika'
                                width: 50, // Širina slike
                                height: 50, // Visina slike
                                fit: BoxFit.cover, // Prilagodba slike
                              )
                            : const Icon(Icons.account_circle,
                                size:
                                    50), // Ikona kao fallback ako slika nije dostupna
                      ),*/
                      DataCell(
                        zaposlenik.korisnik!.slika != null && zaposlenik.korisnik!.slika!.slika != null
                            ? Image.memory(
                                base64Decode(zaposlenik.korisnik!.slika!.slika!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.account_circle, size: 50),
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
                                      builder: (context) => ZaposlenikRecenzijePage(
                                         zaposlenik: zaposlenik),
                                    ),
                                  );
                                }),
                            IconButton(
                                icon: const Icon(Icons.info),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ZaposlenikInfoPage(
                                          zaposlenik: zaposlenik),
                                    ),
                                  );
                                }),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ZaposlenikEditPage(
                                        zaposlenik: zaposlenik),
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
                                print(
                                    'Update clicked for: ${zaposlenik.korisnikId}');
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
                                          "Da li ste sigurni da želite obrisati ovog zaposlenika?"),
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
                                    await _zaposlenikProvider
                                        .delete(zaposlenik.id!);
                                    setState(() {
                                      _zaposlenici.remove(
                                          zaposlenik); // Uklonite obrisanu novost iz liste
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Zaposlenik uspješno obrisan.",
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Zaposlenici"),
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
                            controller: _imeController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po imenu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _prezimeController,
                            decoration: const InputDecoration(
                              labelText: "Pretrazi po prezimenu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _korisnickoImeController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po korisnickom imenu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedUloga,
                            decoration: const InputDecoration(
                              labelText: "Pretrazi po ulozi",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.filter_list),
                            ),
                            items: ulogeOption?.map((naziv) {
                              return DropdownMenuItem<String>(
                                value: naziv,
                                child: Text(naziv),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedUloga = value!;
                                print("selected ULOGA $selectedUloga");
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _imeController.clear();
                            _prezimeController.clear();
                            _korisnickoImeController.clear();
                            setState(() {
                              selectedUloga = "Sve";
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
                                'Ime': _imeController.text,
                                'Prezime': _prezimeController.text,
                                'KorisnickoIme': _korisnickoImeController.text,
                                //'Uloga': selectedUloga == "Sve" ? null : selectedUloga,
                                /*'Status':
                                    _selectedStatus, */ // Dodajemo status u filter
                              };
                              if (selectedUloga != "Sve") {
                                filter['Uloga'] = selectedUloga;
                              }
                              var data =
                                  await _zaposlenikProvider.get(filter: filter);
                              setState(() {
                                _zaposlenici =
                                    data.result; // Ažurirajte listu komentara
                              });
                              print(data.result);
                            } catch (e) {
                              print("Došlo je do greške prilikom pretrage: $e");
                              setState(() {
                                _zaposlenici =
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
                                builder: (context) => ZaposlenikDetaljiPage(),
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
                              Text("Dodaj novog zaposlenika"), // Tekst dugmeta
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildZaposlenikTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
