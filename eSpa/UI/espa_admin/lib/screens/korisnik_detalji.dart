import 'package:espa_admin/models/korisnik.dart';
import 'package:flutter/material.dart';
import 'package:espa_admin/widgets/master_screen.dart';

// ignore: must_be_immutable
class KorisnikDetaljiPage extends StatefulWidget {
  Korisnik? korisnik;
  KorisnikDetaljiPage({Key? key, this.korisnik}) : super(key: key);

  @override
  State<KorisnikDetaljiPage> createState() => _KorisnikDetaljiPageState();
}

class _KorisnikDetaljiPageState extends State<KorisnikDetaljiPage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Container(
            width: 500,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Dodavanje X u gornji desni ugao bez Stack
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(
                          context); // Zatvara stranicu kada se klikne X
                    },
                  ),
                ),
                _buildKorisnikDetails(context),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigacija nazad
                  },
                  // ignore: sort_child_properties_last
                  child: Text('Nazad'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
      title: this.widget.korisnik?.korisnickoIme ?? "Korisnik detalji",
    );
  }

  Widget _buildKorisnikDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDisplayField(label: "Ime", value: widget.korisnik?.ime),
          SizedBox(height: 10),
          _buildDisplayField(label: "Prezime", value: widget.korisnik?.prezime),
          SizedBox(height: 10),
          _buildDisplayField(label: "Email", value: widget.korisnik?.email),
          SizedBox(height: 10),
          _buildDisplayField(label: "Telefon", value: widget.korisnik?.telefon),
          SizedBox(height: 10),
          _buildDisplayField(
              label: "Korisničko ime", value: widget.korisnik?.korisnickoIme),
          SizedBox(height: 10),
          _buildDisplayField(label: "Status", value: widget.korisnik?.status),
          SizedBox(height: 10),
         /* _buildDisplayField(
            label: "Admin",
            value: widget.korisnik?.isAdmin == true ? "Da" : "Ne",
          ),*/
          //_buildDisplayField(label: "Admin", value: widget.korisnik?.isAdmin.toString()),
        ],
      ),
    );
  }

  Widget _buildDisplayField({required String label, required String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: TextEditingController(text: value ?? 'Nema podataka'),
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              enabled: false,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
