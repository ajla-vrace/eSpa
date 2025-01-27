import 'package:espa_admin/models/komentar.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/komentar_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class KomentarPage extends StatefulWidget {
  const KomentarPage({super.key});

  @override
  _KomentarPageState createState() => _KomentarPageState();
}

class _KomentarPageState extends State<KomentarPage> {
  TextEditingController _ftsController = TextEditingController();
  List<Komentar> _komentari = [];
  bool _isKomentariLoading = true;
  SearchResult<Komentar>? result;
  late KomentarProvider _komentarProvider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _komentarProvider = context.read<KomentarProvider>();
  }
  @override
  void initState() {
    super.initState();
    _loadKomentari();
  }

  Future<void> _loadKomentari() async {
    try {
      final komentari =
          await Provider.of<KomentarProvider>(context, listen: false).get();
      setState(() {
        _komentari = komentari.result;
        _isKomentariLoading = false;
      });
    } catch (e) {
      setState(() {
        _isKomentariLoading = false;
      });
    }
  }

  Widget _buildKomentariTable() {
    if (_isKomentariLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_komentari.isEmpty) {
      return const Center(child: Text("Nema komentara."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.green.shade100),
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.green.shade200;
          }
          return Colors.white;
        }),
        columns: const [
          DataColumn(
              label: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Korisnik ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Usluga ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Tekst", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Datum", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _komentari.map((komentar) {
          return DataRow(
            cells: [
              DataCell(Text(komentar.id?.toString() ?? "N/A")),
              DataCell(Text(komentar.korisnikId?.toString() ?? "N/A")),
              DataCell(Text(komentar.uslugaId?.toString() ?? "N/A")),
              DataCell(Text(komentar.tekst ?? "N/A")),
              DataCell(Text(DateFormat('dd.MM.yyyy.')
                  .format(komentar.datum ?? DateTime.now()))),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Usluge i Komentari"),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Tabela Komentara",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              // Novi red za input i dugme
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ftsController,
                        decoration: const InputDecoration(
                          labelText: "Pretraži komentare",
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
                        //final searchTerm = _ftsController.text;

                        // Pozivanje pretrage sa backend-a koristeći provider
                        try {
                          /*final searchResult =
                              await Provider.of<KomentarProvider>(
                            context,
                            listen: false,
                          ).get(filter:{
                            'fts': searchTerm
                          }); // Prosledite parametar pretrage kao mapa
*/
                          var data = await _komentarProvider.get(filter: {
                            'fts': _ftsController.text
                          });
                          setState(() {
                            _komentari =data.result; // Ažurirajte listu komentara
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildKomentariTable(),
            ],
          ),
        ),
      ),
    );
  }
}
