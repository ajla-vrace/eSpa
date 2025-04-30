import 'package:espa_mobile/models/kategorija.dart';
import 'package:espa_mobile/models/usluga.dart';
import 'package:espa_mobile/providers/kategorija_provider.dart';
import 'package:espa_mobile/providers/usluga_provider.dart';
import 'package:espa_mobile/screens/usluga_detalji.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PretragaScreen extends StatefulWidget {
  const PretragaScreen({Key? key}) : super(key: key);

  @override
  _PretragaScreenState createState() => _PretragaScreenState();
}

class _PretragaScreenState extends State<PretragaScreen> {
  List<Kategorija> _kategorije = [];
  List<Usluga> _usluge = [];
  String? _selectedKategorija;
  String _searchTerm = '';
  bool _isLoading = true;

  final List<Color> _chipColors = [
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.brown,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _loadKategorije();
    _loadSveUsluge();
  }

  Future<void> _loadKategorije() async {
    try {
      final kategorije = await Provider.of<KategorijaProvider>(context, listen: false).get();
      setState(() {
        _kategorije = kategorije.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSveUsluge() async {
    try {
      final usluge = await Provider.of<UslugaProvider>(context, listen: false).get();
      setState(() {
        _usluge = usluge.result;
      });
    } catch (e) {
      debugPrint("Greška pri dohvaćanju usluga: $e");
    }
  }

  /*List<Usluga> get _filtriraneUsluge {
    List<Usluga> filtrirane = _usluge;

    if (_selectedKategorija != null) {
      filtrirane = filtrirane.where((u) => u.kategorija == _selectedKategorija).toList();
    }

    if (_searchTerm.isNotEmpty) {
      filtrirane = filtrirane
          .where((u) => u.naziv!.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    }

    return filtrirane;
  }*/
  List<Usluga> get _filtriraneUsluge {
  return _usluge.where((u) {
    final matchesKategorija = _selectedKategorija == null || u.kategorija.naziv == _selectedKategorija;
    final matchesSearchTerm = _searchTerm.isEmpty || u.naziv!.toLowerCase().contains(_searchTerm.toLowerCase());
    return matchesKategorija && matchesSearchTerm;
  }).toList();
}


  void _ponistiKategoriju() {
    setState(() {
      _selectedKategorija = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Pretraga',
      selectedIndex: 1,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // 🔍 Input za pretragu
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Pretraži usluge',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() {
                      _searchTerm = value;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // 📂 Lista kategorija kao dugmad u više redova
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...List.generate(_kategorije.length, (index) {
                        final kategorija = _kategorije[index];
                        final isSelected = _selectedKategorija == kategorija.naziv;
                        final color = _chipColors[index % _chipColors.length];
                        return ChoiceChip(
                          label: Text(kategorija.naziv ?? 'Bez naziva'),
                          selected: isSelected,
                          selectedColor: color.withOpacity(0.7),
                          backgroundColor: color.withOpacity(0.3),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) => setState(() {
                            _selectedKategorija = kategorija.naziv;
                          }),
                        );
                      }),
                      if (_selectedKategorija != null)
                        ActionChip(
                          label: const Text('Poništi'),
                          avatar: const Icon(Icons.clear, size: 18),
                          onPressed: _ponistiKategoriju,
                          backgroundColor: Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🛎️ Lista usluga u mreži sa po dvije kartice u redu
                  if (_searchTerm.isNotEmpty || _selectedKategorija != null)
                    Expanded(
                      child: _filtriraneUsluge.isEmpty
                          ? const Center(child: Text('Nema usluga za prikaz'))
                          : GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Broj kolona
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 0.8, // Odnos širine i visine kartice
                              ),
                              itemCount: _filtriraneUsluge.length,
                              itemBuilder: (context, index) {
                                final usluga = _filtriraneUsluge[index];
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => UslugaDetailScreen(usluga: usluga),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Slika usluge
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(12)),
                                          child: usluga.opis != null
                                              ? Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                usluga.naziv ?? 'Bez naziva',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                usluga.opis ?? 'Bez opisa',
                                                style: const TextStyle(fontSize: 14),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                ],
              ),
            ),
    );
  }
}
