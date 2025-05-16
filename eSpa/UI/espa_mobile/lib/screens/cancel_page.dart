import 'package:espa_mobile/models/rezervacija.dart';
import 'package:espa_mobile/providers/rezervacija_provider.dart';
import 'package:espa_mobile/screens/rezervacije.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CancelPage extends StatefulWidget {
  final Rezervacija? lastRezervacija;

  CancelPage({super.key, this.lastRezervacija});

  @override
  State<CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  // ignore: unused_field
  late RezervacijaProvider _rezervacijeProvider;
  late final Rezervacija? _lastRezervacija;
  @override
  void initState() {
    super.initState();
    _rezervacijeProvider = context.read<RezervacijaProvider>();
    _lastRezervacija = widget.lastRezervacija;
  }

  Future<void> _updateRezervacija() async {
    try {
      // ignore: unused_local_variable
      var delete = await _rezervacijeProvider.delete(_lastRezervacija!.id!);
      print("uodate $delete");
      /*Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RezervacijeScreen(),
        ),
      );*/
      // Navigator.pushReplacementNamed(context, '/rezervacije');
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/rezervacije',
        (Route<dynamic> route) => false,
      );
    } catch (err) {
      setState(() {
        // _isLoading = false;
      });
      print("Error updating reservation: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Došlo je do greške pri brisanju rezervacije!")),
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
            Icon(Icons.cancel, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              "Vaše plaćanje je otkazano.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Vrati se na rezervacije.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateRezervacija();
                /*Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RezervacijeScreen(),
                  ),
                );*/
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/rezervacije',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Rezervacije"),
            ),
          ],
        ),
      ),
    );
  }
}
