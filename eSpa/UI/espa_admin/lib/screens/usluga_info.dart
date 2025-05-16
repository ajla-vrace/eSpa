import 'dart:convert';
import 'dart:typed_data';

import 'package:espa_admin/models/ocjena.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/usluga.dart';
import 'package:espa_admin/models/zaposlenik.dart';
import 'package:espa_admin/providers/ocjena_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/providers/zaposlenik_provider.dart';
import 'package:espa_admin/utils/util.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UslugaInfoPage extends StatefulWidget {
  final Usluga? usluga;
  const UslugaInfoPage({Key? key, this.usluga}) : super(key: key);

  @override
  State<UslugaInfoPage> createState() => _UslugaInfoPageState();
}

class _UslugaInfoPageState extends State<UslugaInfoPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UslugaProvider _uslugaProvider;
  late OcjenaProvider _ocjenaProvider;
  SearchResult<Usluga>? uslugaResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.usluga?.naziv,
      'opis': widget.usluga?.opis,
      'cijena': widget.usluga?.cijena?.toStringAsFixed(0),
      'trajanje': widget.usluga?.trajanje?.toString(),
      'kategorijaId': widget.usluga?.kategorijaId?.toString(),
      'slika': widget.usluga?.slika,
      'kategorija': widget.usluga?.kategorija!.naziv,
    };

    _uslugaProvider = context.read<UslugaProvider>();
    _ocjenaProvider = context.read<OcjenaProvider>();
    initForm();
    _loadOcjene();
  }

  Future initForm() async {
    uslugaResult = await _uslugaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  //var _ocjene;
  var result;
  var _ocjene = <Ocjena>[]; // bolje odmah definiraj kao praznu listu
  //bool _isOcjenaLoading = true;
  Future<void> _loadOcjene() async {
    //print("u load ocjene smo sada");
    try {
      print("sada smo u try bloku");
      print("username ${LoggedUser.korisnickoIme}");
      print("usluga ${widget.usluga!.naziv}");
      /*final ocjene = await Provider.of<OcjenaProvider>(context, listen: false)
          //print("komentari su ovdje $ocjene");
          .get(filter: {'Korisnik': LoggedUser.korisnickoIme, 'Usluga': widget.usluga!.naziv});*/
      // 1. Bez filtera
      /* final ocjeneSve =
          await Provider.of<OcjenaProvider>(context, listen: false).get();
      print("Sve ocjene: ${ocjeneSve.result}");*/

// 2. Sa malim slovima u filteru
      /* final ocjeneFilter =
          await Provider.of<OcjenaProvider>(context, listen: false).get(
              filter: {
            'Korisnik': LoggedUser.korisnickoIme,
            'Usluga': widget.usluga!.naziv
          });*/

      final ocjeneFilter = await _ocjenaProvider.get(filter: {
       /* 'Korisnik': LoggedUser.korisnickoIme,*/
        'Usluga': widget.usluga!.naziv
      });
      print("Filterirane ocjene : ${ocjeneFilter}");
      print("result ${ocjeneFilter.result}");
      setState(() {
        //print("u loadkomentari komentari su $ocjene");
        //result=ocjene.result;
        _ocjene = ocjeneFilter.result;
        print("ocjene $_ocjene");
        print("Type of ocjene: ${ocjeneFilter.runtimeType}");
        print("Type of ocjene.result: ${ocjeneFilter.result.runtimeType}");
        print("ocjene.result: ${ocjeneFilter.result}");

        // _isOcjenaLoading = false;
      });
    } catch (e) {
      setState(() {
        //_isOcjenaLoading = false;
        _ocjene = [];
      });
    }
  }

  double izracunajProsjekOcjena() {
    if (_ocjene.isEmpty) {
      print("ocjene list $_ocjene");
      return 0.0; // možeš staviti i 'N/A' ako želiš u tekstu
    }

    double suma = 0;
    for (var ocjena in _ocjene) {
      suma += ocjena.ocjena1!
          .toDouble(); // zamijeni `ocjena1` sa stvarnim imenom polja za ocjenu
    }
    print("suma $suma");
    return suma / _ocjene.length;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Usluga detalji",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
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
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildForm(),
                          const SizedBox(height: 20),
                          _buildBackButton(), // Dugme za nazad
                        ],
                      ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: MouseRegion(
                  cursor: SystemMouseCursors
                      .click, // Promena kursora na "ruku" (pointer)
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context), // Zatvori formu
                    child: const Icon(Icons.close,
                        size: 24, color: Colors.black54),
                  ),
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

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          /* _buildNameFields(),
        
          const SizedBox(height: 10),*/
          _buildDisabledField("Naziv", "naziv", _initialValue['naziv']),
          const SizedBox(height: 10),
          _buildDisabledField("Opis", "opis", _initialValue['opis']),
          const SizedBox(height: 10),
          _buildDisabledField("Cijena (KM)", "cijena", _initialValue['cijena']),
          const SizedBox(height: 10),
          _buildDisabledField(
              "Trajanje (min)", "trajanje", _initialValue['trajanje']),
          const SizedBox(height: 10),
          _buildDisabledField(
              "Kategorija", "kategorija", _initialValue['kategorija']),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min, // da ne zauzima cijelu širinu
            children: [
              Text("Prosjecna ocjena: ",style: TextStyle(fontSize: 14,)),
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                izracunajProsjekOcjena().toStringAsFixed(2),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledField(String label, String name, String? value) {
    return FormBuilderTextField(
      name: name,
      initialValue: value,
      enabled: false, // Onemogućava uređivanje
      style: const TextStyle(
        color: Color.fromARGB(221, 78, 78, 78),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minLines: 1,
      maxLines: null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
      ),
    );
  }

  Widget _buildProfileImage(String? slika) {
    if (slika != null && slika.isNotEmpty) {
      try {
        Uint8List bytes =
            base64Decode(slika); // Dekodiranje slike iz Base64 u Uint8List
        return ClipOval(
          child: Image.memory(
            bytes,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        debugPrint('Greška pri učitavanju slike: $e');
      }
    }

    // Ako nema slike ili dekodiranje ne uspije, prikaži ikonicu
    return const Icon(
      Icons.account_circle,
      size: 100,
      color: Colors.grey,
    );
  }
}
