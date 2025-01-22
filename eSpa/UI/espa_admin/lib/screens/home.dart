/*import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

late UslugaProvider _uslugaProvider;

@override
void didChangeDependencies() {
// TODO: implement didChangeDependencies

super.didChangeDependencies();
_uslugaProvider = context.read<UslugaProvider>();
}

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Home",
      child: Container(
        child:Column(children: [
          Text("Ovo je home page"),
         ElevatedButton( onPressed: () async {
        print("login proceed na home stranici");
        // Navigator.of (context).pop();
        var data = await _uslugaProvider.get(); 
        print("data: $data");
        },
        child: Text("Login"))

        ],)
         
      ),
    );
  }
}*/



/*kod s chatgpt
import 'package:flutter/material.dart';
import '../providers/usluga_provider.dart';
import '../models/usluga.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usluga> usluge = []; // Lista usluga
  bool isLoading = true; // Indikator učitavanja
  String? errorMessage; // Greška ako postoji

  @override
  void initState() {
    super.initState();
    loadUsluge(); // Učitavanje podataka prilikom inicijalizacije
  }

  // Funkcija za učitavanje usluga
  Future<void> loadUsluge() async {
    try {
      setState(() {
        isLoading = true; // Počinje učitavanje
        errorMessage = null; // Resetovanje greške
      });
      UslugaProvider provider = UslugaProvider();
      List<Usluga> fetchedUsluge = await provider.get();
      setState(() {
        usluge = fetchedUsluge; // Postavi usluge u listu
        isLoading = false; // Učitavanje završeno
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = "Greška prilikom učitavanja: $error"; // Postavi grešku
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Usluga"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Prikaz učitavanja
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Prikaz greške
              : ListView.builder(
                  itemCount: usluge.length, // Broj stavki
                  itemBuilder: (context, index) {
                    Usluga usluga = usluge[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(usluga.naziv.toString()), // Naziv usluge
                        subtitle: Text(usluga.opis.toString()), // Opis usluge
                        trailing: Text("${usluga.cijena.toString()} KM"), // Cena usluge
                      ),
                    );
                  },
                ),
    );
  }
}
*/
/* s chatcgpt ali nije centirano i bez boje tabela
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usluga_provider.dart';
import '../models/usluga.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usluga> _usluge = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsluge();
  }

  Future<void> _loadUsluge() async {
    try {
      final usluge = await Provider.of<UslugaProvider>(context, listen: false).get();
      setState(() {
        _usluge = usluge;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom učitavanja podataka: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usluge"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _usluge.isEmpty
              ? Center(child: Text("Nema podataka"))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Naziv")),
                      DataColumn(label: Text("Opis")),
                      DataColumn(label: Text("Cijena")),
                      DataColumn(label: Text("Trajanje")),
                      DataColumn(label: Text("Kategorija ID")),
                    ],
                    rows: _usluge.map((usluga) {
                      return DataRow(
                        cells: [
                          DataCell(Text(usluga.uslugaId?.toString()?? "N/A")),
                          DataCell(Text(usluga.naziv ?? "N/A")),
                          DataCell(Text(usluga.opis ?? "N/A")),
                          DataCell(Text(usluga.cijena?.toStringAsFixed(2) ?? "N/A")),
                          DataCell(Text(usluga.trajanje ?? "N/A")),
                          DataCell(Text(usluga.kategorijaId?.toString() ?? "N/A")),
                        ],
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
*/

/*    OVAJ KOD JE RADI0O I PRIKAZUJE TABELU ZA USLUGE
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usluga_provider.dart';
import '../models/usluga.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usluga> _usluge = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsluge();
  }

  Future<void> _loadUsluge() async {
    try {
      final usluge = await Provider.of<UslugaProvider>(context, listen: false).get();
      setState(() {
        _usluge = usluge.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom učitavanja podataka: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usluge"),
      ),
      body: Container(
        color: Colors.lightBlue.shade50, // Svetloplava pozadina
        alignment: Alignment.center, // Centriranje tabele
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _usluge.isEmpty
                ? Center(child: Text("Nema podataka"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.lightBlue.shade100), // Boja zaglavlja
                      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.lightBlue.shade200; // Boja kada je red selektovan
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
                  ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usluga_provider.dart';
import '../providers/komentar_provider.dart';
import '../models/usluga.dart';
import '../models/komentar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usluga> _usluge = [];
  List<Komentar>? _komentari = [];
  bool _isUslugeLoading = true;
  bool _isKomentariLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsluge();
    _loadKomentari();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom učitavanja podataka: $e')),
      );
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom učitavanja komentara: $e')),
      );
    }
  }

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
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
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

  Widget _buildKomentariTable() {
    if (_isKomentariLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_komentari == null || _komentari!.isEmpty) {
      return const Center(child: Text("Nema dostupnih komentara."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(Colors.green.shade100), // Zaglavlje
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
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
        rows: _komentari!.map((komentar) {
          return DataRow(
            cells: [
              DataCell(Text(komentar.id?.toString() ?? "N/A")),
              DataCell(Text(komentar.korisnikId?.toString() ?? "N/A")),
              DataCell(Text(komentar.uslugaId?.toString() ?? "N/A")),
              DataCell(Text(komentar.tekst ?? "N/A")),
              DataCell(Text(komentar.datum?.toIso8601String() ?? "N/A")),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usluge i Komentari"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Tabela usluga",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildUslugeTable(),
            const SizedBox(height: 40),
            const Text(
              "Tabela komentara",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildKomentariTable(),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:espa_admin/screens/komentari.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usluga_provider.dart';
//import '../providers/komentar_provider.dart';
import '../models/usluga.dart';
//import '../models/komentar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usluga> _usluge = [];
  //List<Komentar> _komentari = [];
  bool _isUslugeLoading = true;
  //bool _isKomentariLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsluge();
   // _loadKomentari();
  }

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

  /*Future<void> _loadKomentari() async {
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
*/
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
/*
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
        rows: _komentari!.map((komentar) {
          return DataRow(
            cells: [
              DataCell(Text(komentar.id?.toString() ?? "N/A")),
              DataCell(Text(komentar.korisnikId?.toString() ?? "N/A")),
              DataCell(Text(komentar.uslugaId?.toString() ?? "N/A")),
              DataCell(Text(komentar.tekst ?? "N/A")),
              DataCell(Text(komentar.datum?.toIso8601String() ?? "N/A")),
            ],
          );
        }).toList(),
      ),
    );
  }
*/


@override
Widget build(BuildContext context) {
  return MasterScreenWidget(
    title: ("Usluge"),
    child: SingleChildScrollView(
      child: Center( // Centriranje celokupnog sadržaja
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Opcionalno dodavanje horizontalnih margina
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Tabela Usluga",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              _buildUslugeTable(),
              const SizedBox(height: 20),
              const Text(
                "Tabela Komentara",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => KomentarPage(),
                    ),
                  );
                },
                child: Text("Idi na komentare"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}




  /*@override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: ("Usluge"),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Tabela Usluga",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            _buildUslugeTable(),
            const SizedBox(height: 20),
            const Text(
              "Tabela Komentara",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
             const SizedBox(height: 20),
             ElevatedButton(onPressed: (){
             Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => /*const*/ KomentarPage(),
                          ),
                        );}, 
             child: Text("Idi na komentare"))
            //_buildKomentariTable(),
          ],
        ),
      ),
)
;
  }*/
}
