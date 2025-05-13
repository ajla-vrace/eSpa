//import 'dart:ffi';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/screens/kategorije.dart';
import 'package:espa_admin/screens/korisnici.dart';
import 'package:espa_admin/screens/novosti.dart';
import 'package:espa_admin/screens/recenzije.dart';
import 'package:espa_admin/screens/rezervacije.dart';
import 'package:espa_admin/screens/termini.dart';
import 'package:espa_admin/screens/usluge.dart';
import 'package:espa_admin/screens/zaposlenici.dart';
import 'package:espa_admin/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:espa_admin/providers/ocjena_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/usluga_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _prosjecneOcjene = []; // Lista za čuvanje prosječnih ocjena

  List _brojRezervacija = [];

  final GlobalKey _chartKey = GlobalKey();
  final GlobalKey _chartKey1 = GlobalKey();

  List<Korisnik> korisnik = [];

  @override
  void initState() {
    super.initState();
    _loadKorisnik();

    // Pozivanje metode za učitavanje prosječnih ocjena nakon što je layout postavljen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProsjek();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRezervacijePoUslugama();
    });
  }

  // Funkcija za učitavanje prosječnih ocjena
  Future<void> loadProsjek() async {
    var nesto = await Provider.of<OcjenaProvider>(context, listen: false)
        .getUslugeProsjecneOcjene();

    print("Dohvaćeni podaci: $nesto"); // Dodajmo ovo za debug

    // ignore: unnecessary_type_check
    if (nesto is List) {
      setState(() {
        _prosjecneOcjene = nesto.where((item) {
          // Proveri da li su ocjene validne
          print("item.prosjecnaocjena ${item['prosjecnaOcjena']}");
          bool valid = item['prosjecnaOcjena'] != null &&
              (item['prosjecnaOcjena'] is num) &&
              (item['prosjecnaOcjena'] >= 0 && item['prosjecnaOcjena'] <= 5);

          if (!valid) {
            print(
                "Nevalidni podaci: $item"); // Prikazivanje nevalidnih podataka
          }
          return valid;
        }).toList();
        print("PROSJECNE OCJENE LISTA $_prosjecneOcjene");
      });
    } else {
      print("Podaci nisu u formatu liste");
    }
  }

  Future<void> _loadKorisnik() async {
    try {
      print("getunsername $getUserName()");
      final korisnikResult =
          await Provider.of<KorisnikProvider>(context, listen: false)
              .get(filter: {'korisnickoIme': getUserName()});
      print("korisnik result $korisnikResult");
      setState(() {
        korisnik = korisnikResult.result;
        print("korisnik $korisnik");
      });
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> loadRezervacijePoUslugama() async {
    var nesto = await Provider.of<UslugaProvider>(context, listen: false)
        .getRezervacijePoUslugama();

    print(
        "Dohvaćeni podaci rezervacije po uslugama: $nesto"); // Dodajmo ovo za debug

    // ignore: unnecessary_type_check
    if (nesto is List) {
      setState(() {
        _brojRezervacija = nesto.where((item) {
          // Proveri da li su ocjene validne
          print("item.brojRezervacija ${item['brojRezervacija']}");
          bool valid = item['brojRezervacija'] != null &&
                  (item['brojRezervacija']
                      is num) /*&&
              (item['prosjecnaOcjena'] >= 0 && item['prosjecnaOcjena'] <= 5)*/
              ;

          if (!valid) {
            print(
                "Nevalidni podaci rezervacije po uslugama: $item"); // Prikazivanje nevalidnih podataka
          }
          return valid;
        }).toList();
        print("BROJ REZERVACIJA LISTAAAA $_brojRezervacija");
      });
    } else {
      print("Podaci nisu u formatu liste");
    }
  }

  // Funkcija za učitavanje usluga
  Future<void> exportChartsToPdf() async {
    try {
      // Render bar chart
      RenderRepaintBoundary boundary1 =
          _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image1 = await boundary1.toImage(pixelRatio: 3.0);
      ByteData? byteData1 =
          await image1.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes1 = byteData1!.buffer.asUint8List();

      // Render pie chart
      RenderRepaintBoundary boundary2 = _chartKey1.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image2 = await boundary2.toImage(pixelRatio: 3.0);
      ByteData? byteData2 =
          await image2.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes2 = byteData2!.buffer.asUint8List();

      // Kreiraj PDF dokument
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text('Chart usluga s prosjecnim ocjenama',
                  style: pw.TextStyle(
                    fontSize: 18,
                  )),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(pngBytes1)),
              pw.SizedBox(height: 20),
              pw.Text('Chart usluga s brojem rezervacija',
                  style: pw.TextStyle(
                    fontSize: 18,
                  )),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(pngBytes2)),
            ],
          ),
        ),
      );

      // Spremi PDF
      final outputDir = await getDownloadsDirectory(); // Za desktop
      final file = File("${outputDir!.path}/grafovi.pdf");
      await file.writeAsBytes(await pdf.save());

      print("PDF spremljen: ${file.path}");
    } catch (e) {
      print("Greška pri eksportovanju: $e");
    }
  }

  Future<void> _exportChart1() async {
    try {
      // Render bar chart
      RenderRepaintBoundary boundary1 =
          _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image1 = await boundary1.toImage(pixelRatio: 3.0);
      ByteData? byteData1 =
          await image1.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes1 = byteData1!.buffer.asUint8List();

      // Kreiraj PDF dokument
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text('Chart usluga s prosjecnim ocjenama',
                  style: pw.TextStyle(
                    fontSize: 18,
                  )),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(pngBytes1)),
              pw.SizedBox(height: 20),
            ],
          ),
        ),
      );

      // Spremi PDF
      final outputDir = await getDownloadsDirectory(); // Za desktop
      final file = File("${outputDir!.path}/graf1.pdf");
      await file.writeAsBytes(await pdf.save());

      print("PDF spremljen: ${file.path}");
    } catch (e) {
      print("Greška pri eksportovanju: $e");
    }
  }

  Future<void> _exportChart2() async {
    try {
      // Render bar chart
      RenderRepaintBoundary boundary1 = _chartKey1.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image1 = await boundary1.toImage(pixelRatio: 3.0);
      ByteData? byteData1 =
          await image1.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes1 = byteData1!.buffer.asUint8List();

      // Kreiraj PDF dokument
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text('Chart broj rezervacija po usluzi',
                  style: pw.TextStyle(
                    fontSize: 18,
                  )),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(pngBytes1)),
              pw.SizedBox(height: 20),
            ],
          ),
        ),
      );

      // Spremi PDF
      final outputDir = await getDownloadsDirectory(); // Za desktop
      final file = File("${outputDir!.path}/graf2.pdf");
      await file.writeAsBytes(await pdf.save());

      print("PDF spremljen: ${file.path}");
    } catch (e) {
      print("Greška pri eksportovanju: $e");
    }
  }

  // Funkcija za generisanje stapastog dijagrama
  Widget _buildBarChart() {
    if (_prosjecneOcjene.isEmpty) {
      return const Center(child: Text('Nema podataka za prikazivanje'));
    }
    return RepaintBoundary(
      key: _chartKey,
      child: SizedBox(
        width: 800,
        height: 400, // definisana visina
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 5,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (BarChartGroupData group) {
                    return const Color.fromARGB(
                        255, 174, 185, 160); // Tooltip boja
                  },
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final usluga = _prosjecneOcjene.firstWhere(
                      (x) => x['uslugaId'] == group.x,
                      orElse: () =>
                          {"naziv": "Nepoznata usluga", "prosjecnaOcjena": 0},
                    );

                    return BarTooltipItem(
                      '${usluga['naziv']}\n',
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'Prosječna ocjena: ${usluga['prosjecnaOcjena'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      final item = _prosjecneOcjene.firstWhere(
                        (x) => x['uslugaId'] == value.toInt(),
                        orElse: () =>
                            {"uslugaId": 0}, // U slučaju da nema podatka
                      );

                      // Generisanje šifre sa prefiksom "U"
                      String sifra = "U${item['uslugaId'] ?? 0}";

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(sifra), // Prikazivanje šifre umesto naziva
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              barGroups: _prosjecneOcjene.map<BarChartGroupData>((item) {
                final uslugaId = item['uslugaId'] ?? 0;
                final prosjecnaOcjena =
                    (item['prosjecnaOcjena'] as num).toDouble();
                return BarChartGroupData(
                  x: uslugaId,
                  barRods: [
                    BarChartRodData(
                      toY: prosjecnaOcjena,
                      color: const Color.fromARGB(255, 47, 92, 49),
                      width: 24,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Funkcija za generisanje stapastog dijagrama
  Widget _buildBarChart1() {
    if (_brojRezervacija.isEmpty) {
      return const Center(child: Text('Nema podataka za prikazivanje'));
    }

    return RepaintBoundary(
      key: _chartKey1,
      child: SizedBox(
        width: 800,
        height: 400, // definisana visina
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 16,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (BarChartGroupData group) {
                    return const Color.fromARGB(
                        255, 174, 185, 160); // Tooltip boja
                  },
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final usluga = _brojRezervacija.firstWhere(
                      (x) => x['uslugaId'] == group.x,
                      orElse: () =>
                          {"naziv": "Nepoznata usluga", "broj rezervacija": 0},
                    );

                    return BarTooltipItem(
                      '${usluga['naziv']}\n',
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'Broj rezervacija : ${usluga['brojRezervacija'].toString()}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      final item = _brojRezervacija.firstWhere(
                        (x) => x['uslugaId'] == value.toInt(),
                        orElse: () =>
                            {"uslugaId": 0}, // U slučaju da nema podatka
                      );

                      // Generisanje šifre sa prefiksom "U"
                      String sifra = "U${item['uslugaId'] ?? 0}";

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(sifra), // Prikazivanje šifre umesto naziva
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              barGroups: _brojRezervacija.map<BarChartGroupData>((item) {
                final uslugaId = item['uslugaId'] ?? 0;
                final prosjecnaOcjena =
                    (item['brojRezervacija'] as num).toDouble();
                return BarChartGroupData(
                  x: uslugaId,
                  barRods: [
                    BarChartRodData(
                      toY: prosjecnaOcjena,
                      color: const Color.fromARGB(255, 47, 92, 49),
                      width: 24,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartWithDescription() {
    return SizedBox(
      height: 400, // 🔁 Postavi visinu da bude ista kao visina grafikona
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart dio
          Expanded(
            flex: 3,
            child: _buildBarChart(),
          ),
          const SizedBox(width: 24),
          // Tekstualni opis
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center, // 🔁 CENTRIRA VERTIKALNO
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // 🔁 Samo zauzmi prostor koji trebaš
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // 🔁 Poravnanje ikone i teksta
                        children: [
                          Icon(Icons.description, size: 20),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Opis grafikona',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              softWrap:
                                  true, // 🔁 Omogućava prelazak u novi red
                              overflow:
                                  TextOverflow.visible, // 🔁 Sprečava overflow
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.bar_chart, size: 20),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text('Analiza prosječnih ocjena usluga'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, size: 20),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Ovaj grafikon prikazuje prosječnu ocjenu svake usluge na temelju korisničkih povratnih informacija',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.cancel, size: 20),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                                'Usluge bez ocjena nisu prikazane na grafikonu.'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.assignment_turned_in, size: 20),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Cilj grafikona je pomoći menadžmentu u donošenju informiranih odluka za unapređenje kvalitete usluga',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning, size: 20),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Napomena: Ocjene su prikazane u rasponu od 1 do 5, gdje 5 označava najviši nivo zadovoljstva korisnika.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () {
                      _exportChart1(); // 👉 funkcija koju ti implementiraš
                    },
                    icon: Icon(Icons.picture_as_pdf,),
                    tooltip: "Export u pdf",
                   // label: Text('Eksportuj grafikon'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReservationsChartWithDescription() {
    return SizedBox(
      height: 400, // 🔁 Postavi visinu da bude ista kao visina grafikona
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tekstualni opis
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal:
                      16.0), // 🔁 Dodaj padding da bi tekst bio u sredini
              child: Align(
                alignment:
                    Alignment.center, // 🔁 Centriraj vertikalno i horizontalno
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // 🔁 Samo zauzmi prostor koji trebaš
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // 🔁 Poravnanje ikone i teksta
                          children: [
                            Icon(Icons.list, size: 20),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Broj rezervacija po uslugama',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                softWrap:
                                    true, // 🔁 Omogućava prelazak u novi red
                                overflow: TextOverflow
                                    .visible, // 🔁 Sprečava overflow
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.date_range, size: 20),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                  'Analiza broja rezervacija za svaku uslugu'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info, size: 20),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Ovaj grafikon prikazuje broj rezervacija za svaku uslugu u poslednjem periodu',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.cancel, size: 20),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Usluge koje nisu imale rezervacije nisu prikazane na grafikonu.',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.assignment_turned_in, size: 20),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Cilj grafikona je pomoći u analizi popularnosti usluga na osnovu broja rezervacija.',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      onPressed: () {
                        _exportChart2(); // 👉 funkcija koju ti implementiraš
                      },
                      icon: Icon(Icons.picture_as_pdf),
                      tooltip: "Export u pdf",
                      //label: Text('Eksportuj grafikon'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Chart dio
          Expanded(
            flex: 3,
            child:
                _buildBarChart1(), // 🛠️ Ovdje pozivaš funkciju za grafikon rezervacija
          ),
        ],
      ),
    );
  }

  // Metoda za izgradnju pozdravne poruke sa zaobljenim donjim ivicama
  Widget buildGreetingMessage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100, // Visina pravougaonika
      decoration: BoxDecoration(
        color: ui.Color.fromARGB(
            255, 243, 244, 235), // Suptilna svetlo bež boja pozadine
        borderRadius:
            BorderRadius.all(Radius.circular(20)), // Blago zaobljene ivice
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: korisnik.isNotEmpty && korisnik.first.ime != null
            ? Text(
                'Dobrodosli, ${LoggedUser.ime}', // Ime korisnika
                style: TextStyle(
                  color: Colors.black, // Tamna boja za tekst za dobar kontrast
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : CircularProgressIndicator(), // Prikazivanje indikatora dok se učitavaju podaci
      ),
    );
  }

  Widget buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Postavljanje dugmadi na početak reda
        children: [
          _buildCircleButton(Icons.person, "Korisnici", KorisnikPage()),
          _buildCircleButton(Icons.work, "Zaposlenici", ZaposlenikPage()),
          _buildCircleButton(Icons.rate_review, "Recenzije", RecenzijaPage()),
          _buildCircleButton(Icons.local_offer, "Usluge", UslugaPage()),
          _buildCircleButton(Icons.category, "Kategorije", KategorijaPage()),
          _buildCircleButton(Icons.access_time, "Termini", TerminPage()),
          _buildCircleButton(Icons.article, "Novosti", NovostPage()),
          _buildCircleButton(
              Icons.book_online, "Rezervacije", RezervacijePage()),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      IconData icon, String label, Widget destinationScreen) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // Razmak između krugova
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Krug sa ikonom
          CircleAvatar(
            radius: 35, // Veličina kruga
            backgroundColor: Colors.blue, // Boja pozadine kruga
            child: Center(
              child: IconButton(
                icon: Icon(
                  icon,
                  color: Colors.white, // Boja ikone
                  size: 24, // Veličina ikone
                ),
                onPressed: () {
                  // Navigacija na odgovarajući ekran
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => destinationScreen),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8), // Razmak između ikone i labela
          // Labela ispod ikone
          Text(
            label,
            style: TextStyle(
              fontSize: 12, // Manji font za labelu
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Home page"),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // Prostor za dugme
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Pozdravna poruka bez paddinga
                  Container(
                    margin: EdgeInsets.zero,
                    // Bez margina, da ne bi bilo paddinga
                    child: buildGreetingMessage(),
                  ),
                  const SizedBox(height: 20),
                  // Ostatak sadržaja sa paddingom
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Padding za ostale elemente
                    child: Column(
                      children: [
                        buildActionButtons(),
                        const SizedBox(height: 20),
                        const Text(
                          "Prosjecne ocjene po uslugama",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        _buildChartWithDescription(),
                        const Text(
                          "Broj rezervacija po uslugama",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        _buildReservationsChartWithDescription(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔘 Dugme u donjem desnom uglu
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => exportChartsToPdf(),
              tooltip: "Export u PDF",
              child: Icon(Icons.picture_as_pdf),
            ),
          ),
        ],
      ),
    );
  }
}
