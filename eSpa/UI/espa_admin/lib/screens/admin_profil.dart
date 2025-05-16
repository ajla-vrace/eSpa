import 'dart:convert';

import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/utils/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdminProfilScreen extends StatefulWidget {
  const AdminProfilScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfilScreen> createState() => _AdminProfilScreenState();
}

class _AdminProfilScreenState extends State<AdminProfilScreen> {
  late KorisnikProvider _korisnikProvider;
  Korisnik? _korisnik;
  bool isLoading = true;
  String? username;
  var _selectedImageBytes;
  // Kontroleri za promjenu lozinke
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showPasswordChange = false;
  bool _isSaveEnabled = false;

  String? fileName;

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    username = LoggedUser.korisnickoIme;
    _loadAdminPodaci();

    // Dodaj listener-e na kontrolere da pratiš promjene i omogućiš dugme "Spremi"
    _currentPasswordController.addListener(_validatePasswords);
    _newPasswordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    final currentPass = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;
    setState(() {
      _isSaveEnabled = currentPass.isNotEmpty &&
          newPass.isNotEmpty &&
          newPass == confirmPass;
    });
  }

  Future<void> _loadAdminPodaci() async {
    try {
      final korisnikResult = await _korisnikProvider.get(filter: {
        'KorisnickoIme': username,
      });

      if (korisnikResult.result.isNotEmpty) {
        setState(() {
          _korisnik = korisnikResult.result[0];
        });
      }
    } catch (e) {
      print("Greška prilikom učitavanja podataka: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    if (_korisnik == null) return;

    final currentPass = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lozinke se ne podudaraju.")),
      );
      return;
    }

    try {
      print("stara lozinka $currentPass");
      print("novin$newPass");
      print("potvrda $confirmPass");
      await _korisnikProvider.changePassword(
          _korisnik!.id!, currentPass, newPass, confirmPass);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Lozinka uspješno promjenjena.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green, // Dodaj zelenu pozadinu
          behavior: SnackBarBehavior.floating, // Opcionalno za lepši prikaz
          duration: Duration(seconds: 3),
        ),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _showPasswordChange = false;
        _isSaveEnabled = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Lozinka neuspješno promjenjena. Provjerite polja.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red, // Dodaj zelenu pozadinu
          behavior: SnackBarBehavior.floating, // Opcionalno za lepši prikaz
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil administratora")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _korisnik == null
              ? Center(child: Text("Korisnik nije pronađen."))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(100),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*if (_korisnik!.slika?.slika != null)
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(_korisnik!.slika!.slika!),
                                )
                              else
                                CircleAvatar(
                                  radius: 50,
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                                ),*/
                              Text(
                                "Podaci o administratoru",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              SizedBox(height: 25),
                              _buildInfoRow(
                                icon: Icons.person,
                                label: "Ime",
                                value:
                                    "${_korisnik!.ime}",
                              ),
                               _buildInfoRow(
                                icon: Icons.person,
                                label: "Prezime",
                                value:
                                    "${_korisnik!.prezime}",
                              ),
                              _buildInfoRow(
                                icon: Icons.email,
                                label: "Email",
                                value: _korisnik!.email ?? "-",
                              ),
                              _buildInfoRow(
                                icon: Icons.account_circle,
                                label: "Korisničko ime",
                                value: _korisnik!.korisnickoIme ?? "-",
                              ),
                              _buildInfoRow(
                                icon: Icons.phone,
                                label: "Telefon",
                                value: _korisnik!.telefon ?? "-",
                              ),
                              SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showPasswordChange = !_showPasswordChange;
                                  });
                                },
                                icon: Icon(Icons.lock),
                                label: Text("Promijeni lozinku"),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              if (_showPasswordChange) ...[
                                SizedBox(height: 15),
                                TextField(
                                  controller: _currentPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Trenutna lozinka",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _newPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Nova lozinka",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Potvrdi novu lozinku",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed:
                                      _isSaveEnabled ? _changePassword : null,
                                  child: Text("Spremi"),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade700),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
