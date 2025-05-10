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
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
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
                  ListTile(
                    title: Text('Korisnici'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KorisnikPage(),
                      ));
                    },
                  ),
                  ListTile(
                    title: Text('Zaposlenici'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ZaposlenikPage(),
                      ));
                    },
                  ),
                  ListTile(
                    title: Text('Usluge'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UslugaPage(),
                      ));
                    },
                  ),
                  ListTile(
                    title: Text('Kategorije'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KategorijaPage(),
                      ));
                    },
                  ),
                  ListTile(
                    title: Text('Termini'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TerminPage(),
                      ));
                    },
                  ),
                  ListTile(
                    title: Text('Recenzije'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RecenzijaPage(),
                      ));
                    },
                  ),
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
