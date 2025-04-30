import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/screens/edit_korisnika.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:espa_mobile/utils/util.dart';

class LicniPodaciScreen extends StatefulWidget {
  const LicniPodaciScreen({super.key});

  @override
  _LicniPodaciScreenState createState() => _LicniPodaciScreenState();
}

class _LicniPodaciScreenState extends State<LicniPodaciScreen> {
  String? korisnickoIme;
  Korisnik? korisnik;
  late int userId;
  SearchResult<Korisnik>? user;

  /*bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadUserData();
      _initialized = true;
    }
  }*/

  @override
  void initState() {
    super.initState();
    _loadUserData();

    
  }

  Future<void> _loadUserData() async {
    korisnickoIme = await getUserName();
    if (korisnickoIme != null) {
      try {
        var korisniciProvider = context.read<KorisnikProvider>();
        user = await korisniciProvider
            .get(filter: {'korisnickoIme': korisnickoIme});
        setState(() {
          korisnik = user?.result[0];
        });
      } catch (e) {
        print("Greška pri učitavanju korisničkih podataka: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (korisnik == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MasterScreenWidget(
      title:"Moji podaci",
      selectedIndex: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //const SizedBox(height: 20),
            const Text(
              'Lični podaci',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Profilna slika
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: korisnik?.status != null
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 10),

            // Odvojeno ime i prezime
            _buildStyledDataRow(
                Icons.person_outline, "Ime", korisnik?.ime ?? "Nepoznato"),
            _buildStyledDataRow(Icons.person_outline, "Prezime",
                korisnik?.prezime ?? "Nepoznato"),
            _buildStyledDataRow(
                Icons.email, "Email", korisnik?.email ?? "Nepoznato"),
            _buildStyledDataRow(
                Icons.phone, "Telefon", korisnik?.telefon ?? "Nepoznato"),
            _buildStyledDataRow(Icons.account_circle, "Korisničko ime",
                korisnik?.korisnickoIme ?? "Nepoznato"),

            const SizedBox(height: 30),

            // Naglašeno dugme za edit
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Navigacija na ekran za uređivanje
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditKorisnikScreen()),
                  );
                  // ignore: unrelated_type_equality_checks
                  if (result == true) {
                    await _loadUserData(); // ponovo učitaj korisnika
                  }
                  //await _loadUserData();
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditKorisnikScreen(korisnik: korisnik!)),
                  ).then((_) {
                    setState(() {
                      _initialized = false; // da bi se ponovo učitali podaci
                    });
                  });*/
                },
                icon: const Icon(Icons.edit, size: 20),
                label: const Text(
                  "Edituj podatke",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            /*ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  ChangePasswordScreen(userId: korisnik!.id!)),
                  );
                },
                child: Text("mienjaj lozinku"))*/
          ],
        ),
      ),
    );
  }

  Widget _buildStyledDataRow(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true, // čini ListTile kompaktnijim
        visualDensity: const VisualDensity(vertical: -3), // manja visina
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        leading: Icon(icon, color: Colors.teal, size: 20),
        title: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
