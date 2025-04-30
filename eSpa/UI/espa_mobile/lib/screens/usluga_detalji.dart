import 'dart:typed_data';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:espa_mobile/models/usluga.dart';

class UslugaDetailScreen extends StatefulWidget {
  final Usluga usluga;

  const UslugaDetailScreen({super.key, required this.usluga});

  @override
  State<UslugaDetailScreen> createState() => _UslugaDetailScreenState();
}

class _UslugaDetailScreenState extends State<UslugaDetailScreen> {
  Uint8List? slikaBytes;

  @override
  void initState() {
    super.initState();

    if (widget.usluga.opis != null) {
      try {
        // slikaBytes = base64Decode(widget.usluga.slika!);
      } catch (e) {
        slikaBytes = null;
      }
    }
  }

  String formatCijena(double? cijena) {
    if (cijena == null) return "N/A";
    return "${cijena.toStringAsFixed(2)} KM";
  }

  String formatTrajanje(String? trajanje) {
    if (trajanje == null) return "Nepoznato trajanje";
    return "$trajanje min";
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Usluga detalji',
      selectedIndex: 1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slika usluge
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: slikaBytes != null
                      ? Image.memory(
                          slikaBytes!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Naziv usluge
                      Text(
                        widget.usluga.naziv ?? "Bez naziva",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Trajanje
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 20, color: Colors.teal),
                          const SizedBox(width: 6),
                          Text(
                            formatTrajanje(widget.usluga.trajanje),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Cijena
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              size: 20, color: Colors.teal),
                          const SizedBox(width: 6),
                          Text(
                            formatCijena(widget.usluga.cijena),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),
// Dugme za rezervaciju termina
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Ovdje ide logika za otvaranje forme za rezervaciju
                            // Na primjer: Navigator.push(...);
                          },
                          child: const Text("Rezerviši termin"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Opis",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Opis usluge
                      Text(
                        widget.usluga.opis ?? "Bez opisa",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
