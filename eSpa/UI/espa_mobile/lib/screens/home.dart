/*import 'dart:convert';
import 'dart:typed_data';

import 'package:espa_mobile/models/novost.dart';
import 'package:espa_mobile/providers/novost_provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading =
      true; // Ova vrednost će biti postavljena na false kad se podaci učitaju
  List<Novost> _novosti = [];

  // ignore: unused_field
  late bool _isNovostLoading;

  @override
  void initState() {
    super.initState();
    _loadNovosti();
  }

  Future<void> _loadNovosti() async {
    try {
      setState(() {
        _isNovostLoading = true; // Učitavanje podataka
      });

      final novosti =
          await Provider.of<NovostProvider>(context, listen: false).get();

      setState(() {
        _novosti = novosti.result; // Pohranjivanje rezultata
        _isNovostLoading = false; // Završeno učitavanje
        _isLoading = false; // Onda postavi _isLoading na false
      });
    } catch (e) {
      setState(() {
        _isNovostLoading =
            false; // Ako dođe do greške, postavi učitavanje na false
        _isLoading = false; // I ovo postavi na false u slučaju greške
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Home",
      selectedIndex: 0,
     // title: ("Novosti"),
      child: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Pokazivanje indikatora dok se podaci učitavaju
          : ListView.builder(
              itemCount: _novosti.length, // Broj stavki u listi

              itemBuilder: (context, index) {
                final novost = _novosti[index];
                Uint8List? slikaBytes;
                try {
                  if (novost.slika != null) {
                    slikaBytes = base64Decode(novost.slika!);
                  }
                } catch (e) {
                  slikaBytes = null;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0), // Odmak lijevo/desno/gore/dolje
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (slikaBytes != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.memory(
                              slikaBytes,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                novost.naslov ?? "Bez naslova",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                novost.sadrzaj ?? "Bez sadržaja",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              /* itemBuilder: (context, index) {
                return Padding(
  padding: const EdgeInsets.all(10.0),
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unutrašnji pravougaonik sa slikom
          if (_novosti[index].slika != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(base64Decode( _novosti[index].slika!),

                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text("Nema slike"),
            ),

          const SizedBox(height: 10),

          // Naslov novosti
          Text(
            _novosti[index].naslov ?? "Nema naslova",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
);

              
              },*/
              ),
    );
  }
}*/
import 'dart:convert';
import 'dart:typed_data';

import 'package:espa_mobile/models/novost.dart';
import 'package:espa_mobile/providers/novost_provider.dart';
import 'package:espa_mobile/screens/novost_detalji.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Novost> _novosti = [];

  // ignore: unused_field
  late bool _isNovostLoading;

  @override
  void initState() {
    super.initState();
    _loadNovosti();
  }

  Future<void> _loadNovosti() async {
    try {
      setState(() {
        _isNovostLoading = true;
      });

      final novosti = await Provider.of<NovostProvider>(context, listen: false)
          .get(filter: {
        'Status': "Aktivna",
      });

      setState(() {
        _novosti = novosti.result;
        _isNovostLoading = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isNovostLoading = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Home",
      selectedIndex: 0,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _novosti.length,
              itemBuilder: (context, index) {
                final novost = _novosti[index];
                Uint8List? slikaBytes;
                try {
                  if (novost.slika != null) {
                    slikaBytes = base64Decode(novost.slika!);
                  }
                } catch (e) {
                  slikaBytes = null;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NovostDetailScreen(novost: novost),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (slikaBytes != null && slikaBytes.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child:
                                // ignore: unnecessary_null_comparison
                                (slikaBytes != null &&
                                        slikaBytes.isNotEmpty &&
                                        slikaBytes.length > 0)
                                    ? Image.memory(
                                        slikaBytes,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 150,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  novost.naslov ?? "Bez naslova",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  novost.sadrzaj ?? "Bez sadržaja",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
