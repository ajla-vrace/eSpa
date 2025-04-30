import 'dart:convert';
import 'dart:typed_data';
import 'package:espa_mobile/models/novost.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovostDetailScreen extends StatefulWidget {
  final Novost novost;

  const NovostDetailScreen({super.key, required this.novost});

  @override
  State<NovostDetailScreen> createState() => _NovostDetailScreenState();
}

class _NovostDetailScreenState extends State<NovostDetailScreen> {
  Uint8List? slikaBytes;

  @override
  void initState() {
    super.initState();

    if (widget.novost.slika != null) {
      try {
        slikaBytes = base64Decode(widget.novost.slika!);
      } catch (e) {
        slikaBytes = null;
      }
    }
  }

  String formatDatum(DateTime? datum) {
    if (datum == null) return "Nepoznat datum";
    return DateFormat('dd-MM-yyyy').format(datum);
  }

  @override
  Widget build(BuildContext context) {
     return MasterScreenWidget(
      title: 'Novost detalji',
      selectedIndex: 0,
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
                if (slikaBytes != null)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.memory(
                      slikaBytes!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.novost.naslov ?? "Bez naslova",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            widget.novost.autor?.korisnickoIme ??
                                "Nepoznat autor",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            formatDatum(widget.novost.datumKreiranja),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),
                     

                       Text(
                        widget.novost.sadrzaj ?? "Bez sadržaja",
                        style: const TextStyle(fontSize: 16, height: 1.5),
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
