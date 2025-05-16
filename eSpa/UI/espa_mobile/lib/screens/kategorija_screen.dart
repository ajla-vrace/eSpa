import 'package:espa_mobile/models/kategorija.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/providers/kategorija_provider.dart'; // Provjeri da li je pravilno importovan

class KategorijaScreen extends StatefulWidget {
  const KategorijaScreen({super.key});

  @override
  _KategorijaScreenState createState() => _KategorijaScreenState();
}

class _KategorijaScreenState extends State<KategorijaScreen> {
  bool _isLoading = true; // Ova vrednost će biti postavljena na false kad se podaci učitaju
  List<Kategorija> _kategorije = [];
   //static const String routeName = "/kategorija";
  // ignore: unused_field
  late bool _isKategorijaLoading;

  @override
  void initState() {
    super.initState();
    _loadKategorije();
  }

  Future<void> _loadKategorije() async {
    try {
      setState(() {
        _isKategorijaLoading = true; // Učitavanje podataka
      });

      final kategorije =
          await Provider.of<KategorijaProvider>(context, listen: false).get();

      setState(() {
        _kategorije = kategorije.result; // Pohranjivanje rezultata
        _isKategorijaLoading = false; // Završeno učitavanje
        _isLoading = false; // Onda postavi _isLoading na false
      });
    } catch (e) {
      setState(() {
        _isKategorijaLoading = false; // Ako dođe do greške, postavi učitavanje na false
        _isLoading = false; // I ovo postavi na false u slučaju greške
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 1,
     // title: ("Novosti"),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Pokazivanje indikatora dok se podaci učitavaju
          : ListView.builder(
              itemCount: _kategorije.length, // Broj stavki u listi
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _kategorije[index].naziv ?? "Nema naziva", // Ako naziv bude null, koristi "Nema naziva"
                  ),
                );
              },
            ),
    );
  }
}
