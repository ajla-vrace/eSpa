// ignore_for_file: prefer_const_constructors

//import 'package:espa_admin/main.dart';
import 'package:espa_admin/screens/home.dart';
import 'package:espa_admin/screens/kategorije.dart';
import 'package:espa_admin/screens/korisnici.dart';
import 'package:espa_admin/screens/novosti.dart';
import 'package:espa_admin/screens/recenzije.dart';
import 'package:espa_admin/screens/rezervacije.dart';
import 'package:espa_admin/screens/termini.dart';
import 'package:espa_admin/screens/usluge.dart';
import 'package:espa_admin/screens/zaposlenici.dart';
import 'package:espa_admin/utils/util.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({this.child, this.title, this.title_widget, Key? key})
      : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  void _logout() async {
    // npr. ako koristiš SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    print("Korisnik je odjavljen");
    //Navigator.pushReplacementNamed(context, '/login');
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false, // uklanja sve prethodne rute
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Uklanjamo `title_widget` i koristimo Row
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Lijevo: naslov
            widget.title_widget ?? Text(widget.title ?? ""),

            // Desno: ikonica i naziv
            Row(
              children: [
                Icon(Icons.spa, size: 24), // ili tvoja custom ikona
                SizedBox(width: 5),
                //Text("eSpa", style: TextStyle(fontWeight: FontWeight.bold)),

                /*Text(
                  "eSpa",
                  style: TextStyle(
                    fontFamily: 'cursive',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),*/
                Text(
                  "eSpa",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('HomePage'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                    },
                  ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Korisnici'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KorisnikPage(),
                        ));
                      },
                    ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Zaposlenici'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ZaposlenikPage(),
                        ));
                      },
                    ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Usluge'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UslugaPage(),
                        ));
                      },
                    ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Kategorije'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KategorijaPage(),
                        ));
                      },
                    ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Termini'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TerminPage(),
                        ));
                      },
                    ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Recenzije'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RecenzijaPage(),
                        ));
                      },
                    ),
                  if (!LoggedUser.isZaposlenik!)
                    ListTile(
                      title: Text('Novosti'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NovostPage(),
                        ));
                      },
                    ),
                  ListTile(
                    title: Text('Rezervacije'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RezervacijePage(),
                      ));
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Odjava'),
              onTap: _logout, // Dodaj funkciju ispod
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
