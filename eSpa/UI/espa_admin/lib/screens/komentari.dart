import 'package:espa_admin/models/komentar.dart';
import 'package:espa_admin/providers/komentar_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
//import '../providers/usluga_provider.dart';
//import '../providers/komentar_provider.dart';
//import '../models/usluga.dart';
//import '../models/komentar.dart';

class KomentarPage extends StatefulWidget {
  const KomentarPage({super.key});

  @override
  _KomentarPageState createState() => _KomentarPageState();
}

class _KomentarPageState extends State<KomentarPage> {
  //List<Usluga> _usluge = [];
  List<Komentar> _komentari = [];
  //bool _isUslugeLoading = true;
  bool _isKomentariLoading = true;

  @override
  void initState() {
    super.initState();
    //_loadUsluge();
    _loadKomentari();
  }
/*
  Future<void> _loadUsluge() async {
    try {
      final usluge =
          await Provider.of<UslugaProvider>(context, listen: false).get();
      setState(() {
        _usluge = usluge.result;
        _isUslugeLoading = false;
      });
    } catch (e) {
      setState(() {
        _isUslugeLoading = false;
      });
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom učitavanja podataka: $e')),
      );*/
    }
  }
*/
  Future<void> _loadKomentari() async {
    try {
      final komentari =
          await Provider.of<KomentarProvider>(context, listen: false).get();
      setState(() {
        _komentari = komentari.result;
        print("komentari: $_komentari");
        _isKomentariLoading = false;
      });
    } catch (e) {
      setState(() {
        _isKomentariLoading = false;
      });
      //ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(content: Text('Greška prilikom učitavanja komentara: $e')),
      //);
    }
  }
/*
  Widget _buildUslugeTable() {
    if (_isUslugeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_usluge.isEmpty) {
      return const Center(child: Text("Nema podataka"));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(Colors.lightBlue.shade100), // Zaglavlje
        dataRowColor: MaterialStateProperty.resolveWith<Color?>((
          Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.lightBlue.shade200; // Boja selektovanog reda
            }
            return Colors.white; // Podrazumevana boja reda
          },
        ),
        columns: const [
          DataColumn(label: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Naziv", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Opis", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Cijena", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Trajanje", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Kategorija ID", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _usluge.map((usluga) {
          return DataRow(
            cells: [
              DataCell(Text(usluga.id?.toString() ?? "nema")),
              DataCell(Text(usluga.naziv ?? "N/A")),
              DataCell(Text(usluga.opis ?? "N/A")),
              DataCell(Text(usluga.cijena?.toStringAsFixed(2) ?? "N/A")),
              DataCell(Text(usluga.trajanje ?? "N/A")),
              DataCell(Text(usluga.kategorijaId?.toString() ?? "N/A")),
            ],
          );
        }).toList(),
      ),
    );
  }
*/
  Widget _buildKomentariTable() {
    if (_isKomentariLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (/*_komentari == null ||*/ _komentari.isEmpty) {
      return const Center(child: Text("Nema komentara."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(Colors.green.shade100), // Zaglavlje
        dataRowColor: MaterialStateProperty.resolveWith<Color?>((
          Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.green.shade200; // Boja selektovanog reda
            }
            return Colors.white; // Podrazumevana boja reda
          },
        ),
        columns: const [
          DataColumn(label: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Korisnik ID", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Usluga ID", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Tekst", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Datum", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _komentari.map((komentar) {
          return DataRow(
            cells: [
              DataCell(Text(komentar.id?.toString() ?? "N/A")),
              DataCell(Text(komentar.korisnikId?.toString() ?? "N/A")),
              DataCell(Text(komentar.uslugaId?.toString() ?? "N/A")),
              DataCell(Text(komentar.tekst ?? "N/A")),
              //DataCell(Text(komentar.datum?.toIso8601String() ?? "N/A")),
               DataCell(Text(DateFormat('dd.MM.yyyy.').format(komentar.datum ?? DateTime.now()))),  // Formatiranje datuma
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
        child:Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Tabela Komentara",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
             const SizedBox(height: 20),
            
            _buildKomentariTable(),
          ],
        ),
        )
      ),
      )
    ;
  }
}
