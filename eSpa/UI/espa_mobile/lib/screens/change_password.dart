import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ako koristiš Provider
import '../providers/korisnik_provider.dart'; // Putanja gdje ti je provider

class ChangePasswordScreen extends StatefulWidget {
  final int userId; // <-- dodaj ovo

  ChangePasswordScreen({required this.userId}); // <-- konstruktor
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Novi password i potvrda nisu isti')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final korisnikProvider =
          Provider.of<KorisnikProvider>(context, listen: false);
      print('UserID: ${widget.userId}');
      await korisnikProvider.changePassword(
        widget.userId, // OVDJE stavi ID ulogovanog korisnika ako ga imaš
        oldPassword,
        newPassword,
        confirmPassword,
      );
      Navigator.pop(context, true);

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );*/

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     return MasterScreenWidget(
      title: "Promjena lozinke",
      selectedIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: 'Stara lozinka'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Nova lozinka'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Potvrda lozinke'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Promjeni lozinku'),
                  ),
          ],
        ),
      ),
    );
  }
}
