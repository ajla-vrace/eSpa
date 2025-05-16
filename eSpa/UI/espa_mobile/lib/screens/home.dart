import 'dart:convert';
import 'dart:typed_data';

import 'package:espa_mobile/models/novost.dart';
import 'package:espa_mobile/providers/novost_provider.dart';
import 'package:espa_mobile/screens/novost_detalji.dart';
import 'package:espa_mobile/utils/util.dart';
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
        itemCount: _novosti.length + 1, // +1 za pozdravni tekst
        itemBuilder: (context, index) {
          if (index == 0) {
            // Ovo je prvi widget — pozdravni tekst
            return Container(
              width: double.infinity,
              color: Color.fromARGB(255, 231, 236, 202), // pozadinska boja
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Dobro došli, ${LoggedUser.ime}!",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          // Ovdje su novosti, ali pomaknute za 1 zbog pozdravnog teksta
          final novost = _novosti[index - 1];
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: (slikaBytes != null &&
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
