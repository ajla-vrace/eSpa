import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/screens/moje_recenzije.dart';
import 'package:espa_mobile/screens/moje_rezervacije.dart';
import 'package:espa_mobile/screens/moji_podaci.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class KorisnickiProfilScreen extends StatefulWidget {
  const KorisnickiProfilScreen({super.key});

  @override
  State<KorisnickiProfilScreen> createState() => _KorisnickiProfilScreenState();
}

class _KorisnickiProfilScreenState extends State<KorisnickiProfilScreen> {
  String? korisnickoIme;
  SearchResult<Korisnik>? user;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Pozivamo funkciju koja učitava podatke o korisniku
  }

  Future<void> _loadUserData() async {
    // Dohvati korisničko ime iz SharedPreferences
    korisnickoIme = await getUserName();

    // Ako korisničko ime nije null, nastavi sa dohvatanjem podataka o korisniku
    if (korisnickoIme != null) {
      try {
        // Koristi provider za dohvatanje korisničkih podataka prema korisničkom imenu
        var korisniciProvider = context.read<KorisnikProvider>();
        user = await korisniciProvider
            .get(filter: {'korisnickoIme': korisnickoIme});

        // Ako su podaci uspešno učitani, update-uj state
        setState(() {});
      } catch (e) {
        // Ako dođe do greške prilikom učitavanja, možeš staviti fallback ili prikazati error poruku
        print("Greška pri učitavanju korisničkih podataka: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Proveravamo da li su podaci o korisniku učitani
    if (user == null) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Pokazivanje indikatora dok se učitavaju podaci
      );
    }

    // Dohvatimo stvarne podatke iz `user` objekta
    var korisnik = user?.result[0];

    return MasterScreenWidget(
      title:"Moj profil",
      selectedIndex: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Moj profil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // prostor između naslova i slike
            // Profilna slika, koristi URL iz podataka korisnika ako postoji
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              //backgroundImage: korisnik?.profilnaSlikaUrl != null
              // ? NetworkImage(korisnik!.profilnaSlikaUrl!)
              // : null,
              child: korisnik?.status != null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 16),
            // Ime i prezime korisnika
            Text(
              "${korisnik?.ime} ${korisnik?.prezime}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildButton(context, "Lični podaci", Icons.person, () {
                    // Navigacija ili logika
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LicniPodaciScreen()),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildButton(
                      context, "Moje rezervacije", Icons.calendar_today, () {
                    // Navigacija ili logika
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MojeRezervacijeScreen()),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildButton(context, "Moje recenzije", Icons.rate_review,
                      () {
                    // Navigacija ili logika
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MojeRecenzijeScreen()),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[50],
          foregroundColor: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
