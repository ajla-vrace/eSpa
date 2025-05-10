import 'package:espa_mobile/models/rezervacija.dart';
import 'package:espa_mobile/providers/rezervacija_provider.dart';
import 'package:espa_mobile/screens/rezervacije.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuccessPage extends StatefulWidget {
  final Rezervacija? lastRezervacija;

  SuccessPage({super.key, this.lastRezervacija});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  // ignore: unused_field
  late RezervacijaProvider _rezervacijeProvider;
  late final Rezervacija? _lastRezervacija;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rezervacijeProvider = context.read<RezervacijaProvider>();
    _lastRezervacija = widget.lastRezervacija;
    
  }

  Future<void> _updateRezervacija() async {
    setState(() {
      _isLoading = true;
    });
    //var request;
    /*var request = RezervacijaUpdate(
        LoggedUser.id,
        _lastRezervacija!.uslugaId,
        _lastRezervacija!.terminId,
        _lastRezervacija!.statusId,
        _lastRezervacija!.isArhiva,
        _lastRezervacija!.datumRezervacije,
        _lastRezervacija!.isArhivaKorisnik,
        false,
        true);*/

    try {
      // ignore: unused_local_variable
     /* var update =
          await _rezervacijeProvider.update(_lastRezervacija!.id!, request);*/
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RezervacijeScreen(),
        ),
      );
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print("Error updating reservation: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Došlo je do greške pri ažuriranju rezervacije!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              "Uspjesno ste platili!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _lastRezervacija != null
                ? _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _updateRezervacija,
                        child: const Text("Pregled rezervacija"),
                      )
                : Text(""),
          ],
        ),
      ),
    );
  }
}
