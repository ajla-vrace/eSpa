import 'package:espa_mobile/screens/change_password.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/utils/util.dart';

class EditKorisnikScreen extends StatefulWidget {
  const EditKorisnikScreen({super.key});

  @override
  State<EditKorisnikScreen> createState() => _EditKorisnikScreenState();
}

class _EditKorisnikScreenState extends State<EditKorisnikScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonController = TextEditingController();

  Korisnik? korisnik;

  @override
  void initState() {
    super.initState();
    _loadKorisnikData();
  }

  Future<void> _loadKorisnikData() async {
    var korisnickoIme = await getUserName();
    var korisnikProvider = context.read<KorisnikProvider>();
    var response =
        await korisnikProvider.get(filter: {'korisnickoIme': korisnickoIme});
    korisnik = response.result.first;

    setState(() {
      _imeController.text = korisnik?.ime ?? "";
      _prezimeController.text = korisnik?.prezime ?? "";
      _emailController.text = korisnik?.email ?? "";
      _telefonController.text = korisnik?.telefon ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Editovanje korisnika",
      selectedIndex: 3,
      child: korisnik == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      controller: _imeController,
                      label: "Ime",
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ime je obavezno";
                        }

                        // Provera da li je ime/prezime minimalno 3 karaktera, samo slova, i prvo slovo veliko
                        if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) {
                          return 'Polje može sadržati samo slova';
                        }
                        if (value.length < 3) {
                          return 'Unesite najmanje 3 karaktera';
                        }
                        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                          return 'Prvo slovo mora biti veliko';
                        }

                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _prezimeController,
                      label: "Prezime",
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Prezime je obavezno";

                        // Provera da li je ime/prezime minimalno 3 karaktera, samo slova, i prvo slovo veliko
                        if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) {
                          return 'Polje može sadržati samo slova';
                        }
                        if (value.length < 3) {
                          return 'Unesite najmanje 3 karaktera';
                        }
                        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                          return 'Prvo slovo mora biti veliko';
                        }

                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Email je obavezan";
                        if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Unesite validan email';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _telefonController,
                      label: "Telefon",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Telefon je obavezan";
                        if (!RegExp(r'^06\d{7}$').hasMatch(value)) {
                          return 'Broj telefona mora počinjati s "06" i imati 9 cifara"';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // OVDJE UBACUJEŠ NOVO DUGME
                    /* ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(userId: korisnik!.id!,)),
                        );
                      },
                      child: const Text("Promijeni lozinku"),
                    ),*/

                    OutlinedButton(
                      onPressed: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangePasswordScreen(userId: korisnik!.id!),
                          ),
                        );
                        if (result == true) {
                          // Ako je lozinka promijenjena, možeš prikazati kratku poruku
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Lozinka je uspješno promijenjena")),
                          );
                        }
                      },
                      child: const Text("Promijeni lozinku"),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            korisnik?.ime = _imeController.text;
                            korisnik?.prezime = _prezimeController.text;
                            korisnik?.email = _emailController.text;
                            korisnik?.telefon = _telefonController.text;

                            await context
                                .read<KorisnikProvider>()
                                .update(korisnik!.id!, korisnik!);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Podaci su uspješno ažurirani")),
                            );
                            /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LicniPodaciScreen()),
                            );*/
                            //await _loadKorisnikData();
                            //Navigator.pop(context);
                            Navigator.pop(context, true);
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Greška"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Sačuvaj promjene"),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
