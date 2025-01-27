import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NovostPage extends StatefulWidget {
  const NovostPage({super.key});

  @override
  _NovostPageState createState() => _NovostPageState();
}

class _NovostPageState extends State<NovostPage> {
  List<Novost> _novosti = [];
  bool _isNovostLoading = true;

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

  Widget _buildNovostiTable() {
    if (_isNovostLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_novosti.isEmpty) {
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
                columnSpacing: constraints.maxWidth * 0.2, // Prostor između kolona
                headingRowColor: MaterialStateProperty.all(
                  Colors.green.shade800), // Tamnozelena boja za zaglavlje
              dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return const Color.fromARGB(255, 181, 226, 182); // Svetlozelena boja za redove
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
                ],
                rows: _novosti.map((novost) {
                  return DataRow(
                    cells: [
                      DataCell(Text(novost.id?.toString() ?? "N/A")),
                      DataCell(Text(novost.naslov ?? "N/A")),
                      DataCell(Text(novost.sadrzaj ?? "N/A")),
                      DataCell(Text(DateFormat('dd.MM.yyyy.').format(novost.datum ?? DateTime.now()))),
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
                const Text(
                  "Tabela Novosti",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                _buildNovostiTable(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
