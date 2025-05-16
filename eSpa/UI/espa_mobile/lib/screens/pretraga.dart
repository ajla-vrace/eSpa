import 'dart:convert';
import 'package:espa_mobile/models/kategorija.dart';
import 'package:espa_mobile/models/usluga.dart';
import 'package:espa_mobile/models/zaposlenik.dart';
import 'package:espa_mobile/providers/kategorija_provider.dart';
import 'package:espa_mobile/providers/usluga_provider.dart';
import 'package:espa_mobile/providers/zaposlenik_provider.dart';
import 'package:espa_mobile/screens/usluga_detalji.dart';
import 'package:espa_mobile/screens/zaposlenik_detalji.dart';
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
  final ScrollController _scrollController = ScrollController();

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

  List<Zaposlenik>? _zaposlenici;

  @override
  void initState() {
    super.initState();
    _loadKategorije();
    _loadSveUsluge();
    _loadZaposlenici();
  }

  Future<void> _loadZaposlenici() async {
    try {
      final zaposlenici =
          await Provider.of<ZaposlenikProvider>(context, listen: false).get();
      setState(() {
        _zaposlenici = zaposlenici.result;
      });
    } catch (e) {
      debugPrint("Greška pri dohvaćanju zaposlenika: $e");
    }
  }

  Future<void> _loadKategorije() async {
    try {
      final kategorije =
          await Provider.of<KategorijaProvider>(context, listen: false).get();
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
      final usluge =
          await Provider.of<UslugaProvider>(context, listen: false).get();
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
      final matchesKategorija = _selectedKategorija == null ||
          u.kategorija.naziv == _selectedKategorija;
      final matchesSearchTerm = _searchTerm.isEmpty ||
          u.naziv!.toLowerCase().contains(_searchTerm.toLowerCase());
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
          : SafeArea(
              child: Padding(
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

                    // 📂 Lista kategorija
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ...List.generate(_kategorije.length, (index) {
                          final kategorija = _kategorije[index];
                          final isSelected =
                              _selectedKategorija == kategorija.naziv;
                          final color = _chipColors[index % _chipColors.length];

                          return ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 120),
                            child: ChoiceChip(
                              label: Text(kategorija.naziv ?? 'Bez naziva'),
                              selected: isSelected,
                              selectedColor: color.withOpacity(0.7),
                              backgroundColor: color.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: BorderSide(
                                  color: isSelected ? Colors.white : color,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              onSelected: (_) => setState(() {
                                _selectedKategorija = kategorija.naziv;
                              }),
                            ),
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

                    // 🔄 Glavni sadržaj (usluge + zaposlenici)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // 🛎️ Prikaz filtriranih usluga
                            if (_searchTerm.isNotEmpty ||
                                _selectedKategorija != null)
                              _filtriraneUsluge.isEmpty
                                  ? const Center(
                                      child: Text('Nema usluga za prikaz'))
                                  : GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(8.0),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: _filtriraneUsluge.length,
                                      itemBuilder: (context, index) {
                                        final usluga = _filtriraneUsluge[index];
                                        return Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      UslugaDetailScreen(
                                                          usluga: usluga),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                              .vertical(
                                                          top: Radius.circular(
                                                              12)),
                                                  child: usluga.slika != null &&
                                                          usluga
                                                              .slika!.isNotEmpty
                                                      ? Image.memory(
                                                          base64Decode(
                                                              usluga.slika!),
                                                          height: 120,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(
                                                          height: 120,
                                                          width:
                                                              double.infinity,
                                                          color:
                                                              Colors.grey[300],
                                                          child: const Icon(
                                                            Icons.image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: Text(
                                                          usluga.naziv ??
                                                              'Bez naziva',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      /*Text(
                                                        '${usluga.cijena ?? 'Bez opisa'} KM',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),*/
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                            const SizedBox(height: 20),

                            // 👥 Sekcija za zaposlenike
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Naši zaposlenici',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            SizedBox(
                              height: 220.0,
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                // itemCount: _zaposlenici!.length,
                                itemCount: _zaposlenici != null
                                    ? _zaposlenici!.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  final zaposlenik = _zaposlenici![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ZaposlenikDetaljiScreen(
                                            zaposlenik: zaposlenik,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 160.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 5.0),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: (zaposlenik.korisnik?.slika != null &&
                                                    zaposlenik.korisnik!.slika!.slika!
                                                        .isNotEmpty)
                                                ? Image.memory(
                                                    base64Decode(zaposlenik
                                                        .korisnik!
                                                        .slika!
                                                        .slika!),
                                                    height: 80.0,
                                                    width: 80.0,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 40.0,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            '${zaposlenik.korisnik?.ime ?? ''} ${zaposlenik.korisnik?.prezime ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            zaposlenik.struka ?? 'Struka',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12.0,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
