import 'dart:convert';
import 'dart:io';

import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/models/slikaProfila.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/slikaProfila_provider.dart';
import 'package:espa_mobile/screens/moje_ocjene_usluga.dart';
import 'package:espa_mobile/screens/moje_recenzije.dart';
import 'package:espa_mobile/screens/moje_recenzijeZaposlenika.dart';
import 'package:espa_mobile/screens/moje_rezervacije.dart';
import 'package:espa_mobile/screens/moji_novostKomentari.dart';
import 'package:espa_mobile/screens/moji_podaci.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:file_picker/file_picker.dart';
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
  Korisnik? korisnik;
  SearchResult<Korisnik>? user;
  String? _fileName;
  String? _fileType;
  File? _image;
  final _korisnikProvider = KorisnikProvider();
  final _slikaProvider = SlikaProfilaProvider();
  String? imagePath;
  bool _imaNovuSliku = false;

  String? _base64image;
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

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_imaNovuSliku)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _image = null;
                _base64image = null;
                _fileName = null;
                _fileType = null;
                _imaNovuSliku = false;
              });
            },
            icon: Icon(Icons.cancel),
            label: Text("Poništi"),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),

        /* _image != null
            ? Image.file(_image!, height: 100)
            : const Text("Nema slike odabrane"),
        const SizedBox(height: 10),*/
        if (_imaNovuSliku == false)
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text("Odaberi sliku"),
          ),
        const SizedBox(height: 10),
        if (_image != null && _imaNovuSliku == true)
          ElevatedButton.icon(
            onPressed: () async {
              var slikaRequest = {
                'naziv': _fileName,
                'slikaBase64': _base64image,
                'tip': _fileType,
              };

              try {
                var slikaResponse = await _slikaProvider.insert(slikaRequest);
                int? slikaId = slikaResponse.id;

                print("Slika sačuvana s ID: $slikaId");

                if (slikaId != null) {
                  var updateRequest = {
                    'ime': korisnik!.ime,
                    'prezime': korisnik!.prezime,
                    'email': korisnik!.email,
                    'telefon': korisnik!.telefon,
                    'status': korisnik!.status,
                    'slikaId': slikaId,
                  };

                  await _korisnikProvider.update(korisnik!.id!, updateRequest);
                  print("Profilna slika ažurirana");
                  korisnik!.slika = SlikaProfila(slikaId, _fileName!,
                      _base64image!, _fileType!, DateTime.now());
                  setState(() {
                    _imaNovuSliku = false;
                  });
                  _loadUserData();
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Slika uspješno sačuvana.'),
                      backgroundColor: Colors.green, // ✅ Zelena boja za uspjeh
                    ),
                  );
                }
              } catch (e) {
                print("Greška: $e");
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Greška pri spremanju slike.'),
                    backgroundColor: Colors.red,),
                  );
                }
              }
            },
            icon: Icon(Icons.save),
            label: Text("Spremi sliku"),
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      imagePath = result.files.single.path!;
      setState(() {
        _image = File(imagePath!);
        _base64image = base64Encode(_image!.readAsBytesSync());
        _fileName = result.files.single.name;
        _fileType = result.files.single.extension ?? 'jpg';
        _imaNovuSliku = true; // važno!
      });
    }
  }

  // ignore: unused_element
  void _saveProfileImage() async {
    if (_image != null) {
      try {
        var slikaRequest = {
          'naziv': _fileName,
          'slikaBase64': _base64image,
          'tip': _fileType,
        };

        var slikaResponse = await _slikaProvider.insert(slikaRequest);
        int? slikaId = slikaResponse.id;

        if (slikaId != null) {
          var updateRequest = {
            'ime': korisnik!.ime,
            'prezime': korisnik!.prezime,
            'email': korisnik!.email,
            'telefon': korisnik!.telefon,
            'slikaId': slikaId,
          };

          await _korisnikProvider.update(korisnik!.id!, updateRequest);
          print("Profilna slika ažurirana");
        }
      } catch (e) {
        print("Greška pri slanju slike: $e");
        _showErrorDialog("Greška pri snimanju slike.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Greška"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Pokazivanje indikatora dok se učitavaju podaci
      );
    }

    korisnik = user?.result[0];

    return MasterScreenWidget(
      title: "Moj profil",
      selectedIndex: 3,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                // Profilna slika, koristi URL iz podataka korisnika ako postoji

                /*ElevatedButton(
                  onPressed: _saveProfileImage,
                  child: Text("Sačuvaj"),
                ),*/

                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: _imaNovuSliku && _image != null
                      ? ClipOval(
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : (korisnik?.slika != null)
                          ? ClipOval(
                              child: Image.memory(
                                base64Decode(korisnik!.slika!.slika!),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                ),

                _buildImagePicker(),
                /* CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: (korisnik?.slika != null)
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(korisnik!.slika!.slika!),
                            fit: BoxFit.cover,
                            width: 100, // možeš prilagoditi veličinu
                            height: 100,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),*/

                const SizedBox(height: 16),
                // Ime i prezime korisnika
                Text(
                  "${korisnik?.ime} ${korisnik?.prezime}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildButton(context, "Lični podaci", Icons.person, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LicniPodaciScreen()),
                        );
                      }),
                      const SizedBox(height: 12),
                      _buildButton(
                          context, "Moje rezervacije", Icons.calendar_today,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MojeRezervacijeScreen()),
                        );
                      }),
                      const SizedBox(height: 12),
                      _buildButton(
                          context, "Moji komentari za novost", Icons.comment,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MojiKomentariScreen()),
                        );
                      }),
                      const SizedBox(height: 12),
                      _buildButton(context, "Moje ocjene za uslugu", Icons.star,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MojeOcjeneScreen()),
                        );
                      }),
                      const SizedBox(height: 12),
                      _buildButton(context, "Moje recenzije zaposlenika",
                          Icons.rate_review_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MojeRecenzijeZaposlenikaScreen()),
                        );
                      }),
                      const SizedBox(height: 12),
                      _buildButton(context, "Moji komentari usluga", Icons.rate_review,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MojeRecenzijeScreen()),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            // Ikona za odjavu u gornjem desnom kutu
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  // Dodaj logiku za odjavu
                  _logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    // Dodaj logiku za odjavu, npr. ukloni korisničke podatke iz SharedPreferences
    print("Korisnik je odjavljen!");
    // Možda trebaš redirectovati korisnika na ekran za prijavu
    Navigator.pushReplacementNamed(context, '/login');
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );*/
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
