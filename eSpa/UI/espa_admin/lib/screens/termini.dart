import 'package:espa_admin/models/termin.dart';
import 'package:espa_admin/providers/termin_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TerminPage extends StatefulWidget {
  const TerminPage({super.key});

  @override
  _TerminPageState createState() => _TerminPageState();
}

class _TerminPageState extends State<TerminPage> {
  List<Termin> _termini = [];
  bool _isTerminLoading = true;

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
                columnSpacing: constraints.maxWidth * 0.2, // Prostor između kolona
                headingRowColor: MaterialStateProperty.all(
                    Colors.lightBlue.shade100), // Boja zaglavlja
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.lightBlue.shade200; // Selektovani red
                    }
                    return Colors.white; // Podrazumevana boja reda
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
                      "Pocetak",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Kraj",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: _termini.map((termin) {
                  return DataRow(
                    cells: [
                      DataCell(Text(termin.id?.toString() ?? "N/A")),
                      DataCell(Text(termin.pocetak ?? "N/A")),
                       DataCell(Text(termin.kraj ?? "N/A")),
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
                const Text(
                  "Tabela Termini",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
