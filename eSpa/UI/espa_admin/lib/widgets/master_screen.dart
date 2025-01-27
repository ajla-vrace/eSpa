// ignore_for_file: prefer_const_constructors

//import 'package:espa_admin/main.dart';
import 'package:espa_admin/screens/home.dart';
import 'package:espa_admin/screens/kategorije.dart';
import 'package:espa_admin/screens/komentari.dart';
import 'package:espa_admin/screens/login.dart';
import 'package:espa_admin/screens/novosti.dart';
import 'package:espa_admin/screens/termini.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';


// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({this.child, this.title, this.title_widget, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Back'),
              onTap: () {
               Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  LoginPage(),
                        ),
                      );
              },
            ),
            ListTile(
              title: Text('Komentar'),
              onTap: () {
                Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  KomentarPage(),
                        ),
                      );
              },
            ),
             ListTile(
              title: Text('Kategorije'),
              onTap: () {
                Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  KategorijaPage(),
                        ),
                      );
              },
            ),
            ListTile(
              title: Text('Termini'),
              onTap: () {
                Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  TerminPage(),
                        ),
                      );
              },
            ),
            ListTile(
              title: Text('Novosti'),
              onTap: () {
                Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  NovostPage(),
                        ),
                      );
              },
            ),
            ListTile(
              title: Text('HomePage'),
              onTap: () {
                Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  HomePage(),
                        ),
                      );
              },
            ),
           
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}