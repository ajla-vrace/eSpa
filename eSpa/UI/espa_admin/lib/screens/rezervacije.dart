import 'package:espa_admin/models/rezervacija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/rezervacija_provider.dart';
import 'package:espa_admin/providers/statusRezervacije_provider.dart';
import 'package:espa_admin/screens/rezervacija_detalji.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/statusRezervacije.dart';

class RezervacijePage extends StatefulWidget {
  const RezervacijePage({super.key});

  @override
  _RezervacijePageState createState() => _RezervacijePageState();
}

class _RezervacijePageState extends State<RezervacijePage> {
  List<Rezervacija> _rezervacije = [];
  bool _isReezrvacijaLoading = true;
  SearchResult<Rezervacija>? result;
  TextEditingController _korisnickoImeController = TextEditingController();
  TextEditingController _uslugaController = TextEditingController();
  String? _selectedStatus = "Sve";

  late RezervacijaProvider _rezervacijaProvider;
  late StatusRezervacijeProvider _statusRezervacijeProvider;

  List<StatusRezervacije> _statusi = [];
//String? _selectedStatus = "Sve";

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
    _rezervacijaProvider = context.read<RezervacijaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadRezervacije();
    _loadStatusi();
  }

  Future<void> _loadRezervacije() async {
    try {
      final rezervacije =
          await Provider.of<RezervacijaProvider>(context, listen: false).get();
      setState(() {
        _rezervacije = rezervacije.result;
        _isReezrvacijaLoading = false;
      });
    } catch (e) {
      setState(() {
        _isReezrvacijaLoading = false;
      });
    }
  }

  void _loadStatusi() async {
    var statusi =
        await Provider.of<StatusRezervacijeProvider>(context, listen: false)
            .get();
    setState(() {
      _statusi = statusi.result;
    });
  }

  Widget _buildRezervacijeTable() {
    if (_isReezrvacijaLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_rezervacije.isEmpty) {
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
                    constraints.maxWidth * 0.08, // Prostor između kolona
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
                      "Korisnicko ime",
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
                      "Datum",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Termin",
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
                      "Placeno",
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
                rows: _rezervacije.map((rezervacija) {
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(rezervacija.korisnik?.korisnickoIme ?? "N/A")),
                      //DataCell(Text(rezervacija.usluga?.naziv ?? "N/A")),
                      /* DataCell(
                        Text(_shortenText(rezervacija.usluga!.naziv ?? '',
                            30)), // Skraćeni sadržaj
                      ),*/
                      DataCell(
                        SizedBox(
                          width: 150, // prilagodi širinu prema tabeli
                          child: Text(
                            rezervacija.usluga?.naziv ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),

                      DataCell(Text(DateFormat('dd.MM.yyyy.')
                          .format(rezervacija.datum ?? DateTime.now()))),
                      //DataCell(Text(rezervacija.termin.pocetak ?? "N/A")),
                      DataCell(
                        Text(
                          // Pretvori string u DateTime
                          DateFormat('HH:mm').format(
                            DateFormat('HH:mm:ss')
                                .parse(rezervacija.termin!.pocetak!),
                          ),
                        ),
                      ),
                      DataCell(Text(rezervacija.status ?? "N/A")),
                      DataCell(
                        Text(rezervacija.isPlaceno! ? "Da" : "Ne"),
                      ),

                      // DataCell(Text(rezervacija.statusRezervacije!.naziv ?? "N/A")),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Poravnavanje ikonica desno
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: (rezervacija.status == "Zavrsena" ||
                                        rezervacija.status == "Otkazana")
                                    ? Colors.grey
                                    : Colors.black, // Promena boje
                              ),
                              onPressed: (rezervacija.status == "Zavrsena" ||
                                      rezervacija.status == "Otkazana")
                                  ? null
                                  : () {
                                      // Onemogućavanje klika
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RezervacijaDetaljiPage(
                                                  rezervacija: rezervacija),
                                        ),
                                      );
                                      print(
                                          'Detalji clicked for: ${rezervacija.id}');
                                    },
                            ),

                            /*IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RezervacijaDetaljiPage(rezervacija: rezervacija),
                                  ),
                                );

                                // Akcija za update
                                print('Detalji clicked for: ${rezervacija.id}');
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
                                          "Da li ste sigurni da želite obrisati ovu rezervaciju?"),
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
                                    await _rezervacijaProvider
                                        .delete(rezervacija.id!);
                                    setState(() {
                                      _rezervacije.remove(
                                          rezervacija); // Uklonite obrisanu novost iz liste
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Rezervacija uspješno obrisana.",
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
      title: ("Rezervacije"),
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
                          child: TextField(
                            controller: _uslugaController,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po usluzi",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        /* Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po statusu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            items: <String>["Sve", "Aktivna", "Otkazana"]
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
                        ),*/
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: "Pretraži po statusu",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: "Sve",
                                child: Text("Sve"),
                              ),
                              ..._statusi
                                  .map((status) => DropdownMenuItem<String>(
                                        value: status
                                            .naziv, // ili status.id.toString() ako filtriraš po ID-u
                                        child: Text(status.naziv ?? ''),
                                      )),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),
                        /*IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: () {
                            _korisnickoImeController.clear();
                            _uslugaController.clear();

                            setState(() {
                              _selectedStatus = "Sve";
                            }); // Briše unos iz polja
                          },
                          tooltip: 'Obriši unos',
                        ),*/
                        (_korisnickoImeController.text.isNotEmpty ||
                                _uslugaController.text.isNotEmpty)
                            ? IconButton(
                                icon: Icon(Icons.backspace, color: Colors.red),
                                onPressed: () {
                                  _korisnickoImeController.clear();
                                  _uslugaController.clear();

                                  setState(() {
                                    _selectedStatus = "Sve";
                                  });
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
                              var filter = {
                                'Korisnik': _korisnickoImeController.text,
                                'Usluga': _uslugaController.text,
                              };

                              // Ako je izabrana vrednost različita od "Sve", dodaj filter za status
                              if (_selectedStatus != null &&
                                  _selectedStatus != "Sve") {
                                filter['Status'] = _selectedStatus!;
                              }

                              var data = await _rezervacijaProvider.get(
                                  filter: filter);
                              setState(() {
                                _rezervacije = data.result;
                              });
                              print(data.result);
                            } catch (e) {
                              print("Došlo je do greške prilikom pretrage: $e");
                              setState(() {
                                _rezervacije =
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
                              Text("Dodaj novu rezervaciju"), // Tekst dugmeta
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildRezervacijeTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
