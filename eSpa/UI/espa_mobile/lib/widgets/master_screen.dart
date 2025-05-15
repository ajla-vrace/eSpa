import 'package:espa_mobile/screens/pretraga.dart';
import 'package:espa_mobile/screens/profil.dart';
import 'package:espa_mobile/screens/rezervacije.dart';
import 'package:flutter/material.dart';
import 'package:espa_mobile/screens/home.dart';
//import 'package:espa_mobile/screens/search.dart'; // Pretpostavljamo da postoji SearchScreen
//import 'package:espa_mobile/screens/profile_screen.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  final Widget child; //Child widget koji će biti prikazan u body-u
  String? title;
  //Widget? title_widget;
  final int? selectedIndex; // Index koji označava koji tab je selektovan

  MasterScreenWidget(
      {required this.child, this.title, this.selectedIndex, super.key});

  @override
  _MasterScreenWidgetState createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      currentIndex = widget.selectedIndex!; // Postavljanje početnog indeksa
    }
  }

  // Funkcija za navigaciju
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index; // Ažuriranje trenutnog indeksa
    });

    // Navigacija prema ekranu na osnovu selektovanog indeksa
    if (currentIndex == 0) {
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );*/
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home', // ili ime rute ako koristiš named routes
        (Route<dynamic> route) => false,
      );
    } else if (currentIndex == 1) {
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PretragaScreen(),
        ),
      );*/
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/pretraga', // ili ime rute ako koristiš named routes
        (Route<dynamic> route) => false,
      );
    } else if (currentIndex == 2) {
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RezervacijeScreen(),
        ),
      );*/
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/rezervacije', // ili ime rute ako koristiš named routes
        (Route<dynamic> route) => false,
      );
    } else if (currentIndex == 3) {
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KorisnickiProfilScreen(),
        ),
      );*/
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/profil', // ili ime rute ako koristiš named routes
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: title_widget ?? const Text(''),
        //title: Text('Master Screen'),
        title: Text(widget.title!),
      ),
      body: widget.child, // Prikazivanje child ekrana
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.selectedIndex != null
            ? widget.selectedIndex!
            : currentIndex, // Trenutni selektovani tab
        onTap: _onItemTapped, // Pozivanje funkcije kad se tapne na ikonu
        selectedItemColor: const Color.fromARGB(
            255, 42, 71, 36), // Žuta boja za selektovani tab
        unselectedItemColor: const Color.fromARGB(
            255, 115, 116, 97), // Siva boja za neselektovane tabove
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pretraga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Rezervacije',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
