import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/models/novostKomentar.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/novostKomentar_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NovostKomentarPage extends StatefulWidget {
  final Novost? novost;

  const NovostKomentarPage({Key? key, this.novost}) : super(key: key);

  @override
  State<NovostKomentarPage> createState() => _NovostKomentarPageState();
}

class _NovostKomentarPageState extends State<NovostKomentarPage> {
  late NovostKomentarProvider _novostKomentarProvider;
  SearchResult<NovostKomentar>? novostKomentarResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _novostKomentarProvider = context.read<NovostKomentarProvider>();
    initForm();
  }

  Future initForm() async {
    novostKomentarResult = await _novostKomentarProvider.get(filter: {
      'Novost': widget.novost!.naslov,
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Recenzija detalji",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Container(
                width: 500,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(), // Gura dugme skroz desno
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.black54),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const Text(
                            "Komentari za novost",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          _buildNovostKomentariList(),
                          const SizedBox(height: 20),
                          _buildBackButton(), // Dugme za nazad
                          const SizedBox(height: 20),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Vrati se nazad
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(
            255, 152, 152, 152), // Tamnija nijansa za dugme
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Nazad",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildNovostKomentariList() {
    if (novostKomentarResult?.result == null ||
        novostKomentarResult!.result.isEmpty) {
      return const Center(child: Text('Nema recenzija za ovog zaposlenika.'));
    }

    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400, // ili koliko želiš da bude maksimalna visina
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          itemCount: novostKomentarResult!.result.length,
          itemBuilder: (context, index) {
            final recenzija = novostKomentarResult!.result[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blueGrey),
                      const SizedBox(width: 8),
                      Text(
                        recenzija.korisnik?.ime ?? 'Nepoznato ime',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.comment, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recenzija.sadrzaj ?? 'Nema komentara',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        recenzija.datumKreiranja != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(recenzija.datumKreiranja!)
                            : 'Nema datuma',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
