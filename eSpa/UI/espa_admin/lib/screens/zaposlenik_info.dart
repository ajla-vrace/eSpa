import 'dart:convert';
import 'dart:typed_data';

import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/zaposlenik.dart';
import 'package:espa_admin/providers/zaposlenik_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ZaposlenikInfoPage extends StatefulWidget {
  final Zaposlenik? zaposlenik;
  const ZaposlenikInfoPage({Key? key, this.zaposlenik}) : super(key: key);

  @override
  State<ZaposlenikInfoPage> createState() => _ZaposlenikInfoPageState();
}

class _ZaposlenikInfoPageState extends State<ZaposlenikInfoPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ZaposlenikProvider _zaposlenikProvider;
  SearchResult<Zaposlenik>? zaposlenikResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.zaposlenik?.korisnik?.ime,
      'prezime': widget.zaposlenik?.korisnik?.prezime,
      'email': widget.zaposlenik?.korisnik?.email,
      'telefon': widget.zaposlenik?.korisnik?.telefon,
       'datumRegistracije': widget.zaposlenik?.korisnik?.datumRegistracije,
      'korisnickoIme': widget.zaposlenik?.korisnik?.korisnickoIme,
      'status': widget.zaposlenik?.korisnik?.status,
      'datumZaposlenja': widget.zaposlenik?.datumZaposlenja,
      'struka': widget.zaposlenik?.struka,
      'napomena': widget.zaposlenik?.napomena,
       'biografija': widget.zaposlenik?.biografija,
    };

    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    initForm();
  }

  Future initForm() async {
    zaposlenikResult = await _zaposlenikProvider.get();
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.zaposlenik?.korisnik?.korisnickoIme ?? "Zaposlenik detalji",
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
          _buildNameFields(),
          /* _buildDisabledField(
              "Ime", "ime", _initialValue['ime']),
          const SizedBox(height: 10),
           _buildDisabledField(
              "Prezime", "prezime", _initialValue['prezime']),*/
          const SizedBox(height: 10),
           _buildDisabledField(
              "Email", "email", _initialValue['email']),
          const SizedBox(height: 10),
          _buildPhoneAndRegistrationDateFields(),
         /*  _buildDisabledField(
              "Telefon", "telefon", _initialValue['telefon']),
          const SizedBox(height: 10),
           _buildDisabledField(
              "Datum registracije",
              "datumRegistracije",
              _initialValue['datumRegistracije'] != null
                  ? DateFormat('d.M.yyyy')
                      .format(DateTime.parse(_initialValue['datumRegistracije'].toString()))
                  : ''),*/
         // _buildDisabledField(
            //  "Datum registracije", "datumRegistracije", _initialValue['datumRegistracije']),
          const SizedBox(height: 10),
          _buildDisabledField("Korisnicko ime", "korisnickoIme", _initialValue['korisnickoIme']),
          const SizedBox(height: 10),
          _buildStatusAndDatumZaposlenjaFields(),
         /* _buildDisabledField("Status", "status", _initialValue['status']),
          const SizedBox(height: 10),
          //_buildDisabledField("Datum", "datum", _initialValue['datum']?.toString()),
          _buildDisabledField(
              "Datum zaposlenja",
              "datumZaposlenja",
              _initialValue['datumZaposlenja'] != null
                  ? DateFormat('d.M.yyyy')
                      .format(DateTime.parse(_initialValue['datumZaposlenja'].toString()))
                  : ''),*/
                  const SizedBox(height: 10),

                   _buildDisabledField("Struka", "struka", _initialValue['struka']),
          const SizedBox(height: 10),
           _buildDisabledField("Napomena", "napomena", _initialValue['napomena']),
          const SizedBox(height: 10),
           _buildDisabledField("Biografija", "biografija", _initialValue['biografija']),
          const SizedBox(height: 10),
          _buildProfileImage(widget.zaposlenik?.slika?.slika),
        ],
      ),
    );
  }


Widget _buildPhoneAndRegistrationDateFields() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: _buildDisabledField("Telefon", "telefon", _initialValue['telefon']),
      ),
      const SizedBox(width: 10), // Razmak između polja
      Expanded(
        child: _buildDisabledField(
          "Datum registracije",
          "datumRegistracije",
          _initialValue['datumRegistracije'] != null
              ? DateFormat('d.M.yyyy').format(DateTime.parse(_initialValue['datumRegistracije'].toString()))
              : '',
        ),
      ),
    ],
  );
}

Widget _buildStatusAndDatumZaposlenjaFields() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: _buildDisabledField(
          "Status",
          "status",
          _initialValue['status'], // Status kao tekst
        ),
      ),
      const SizedBox(width: 10), // Razmak između polja
      Expanded(
        child: _buildDisabledField(
          "Datum zaposlenja",
          "datumZaposlenja",
          _initialValue['datumZaposlenja'] != null
              ? DateFormat('d.M.yyyy').format(DateTime.parse(_initialValue['datumZaposlenja'].toString())) // Formatira datum
              : '',
        ),
      ),
    ],
  );
}


Widget _buildNameFields() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: _buildDisabledField("Ime", "ime", _initialValue['ime']),
      ),
      const SizedBox(width: 10), // Razmak između polja
      Expanded(
        child: _buildDisabledField("Prezime", "prezime", _initialValue['prezime']),
      ),
    ],
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
      ),
    );
  }
  /*Widget _buildProfileImage(Uint8List? imageData) {
  return imageData != null
      ? Image.memory(
          imageData,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        )
      : const Icon(
          Icons.account_circle,
          size: 100,
          color: Colors.grey,
        );
}
*/
Widget _buildProfileImage(String? slika) {
  if (slika != null && slika.isNotEmpty) {
    try {
      Uint8List bytes = base64Decode(slika); // Dekodiranje slike iz Base64 u Uint8List
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
/*
  Widget _buildDisabledField3(String label, String name, String? value) {
    return Container(
      height: 80, // Fiksna visina polja
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Omogućava vertikalni skrol
        physics:
            const AlwaysScrollableScrollPhysics(), // Osigurava da skrol uvek bude dostupan
        child: FormBuilderTextField(
          name: name,
          initialValue: value,
          enabled: false, // Onemogućava uređivanje
          maxLines: null, // Omogućava neograničen broj linija
          style: const TextStyle(
            color: Color.fromARGB(221, 87, 87, 87),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: label,
            //alignLabelWithHint: true, // ✅ Popravlja problem sa labelom
            border: InputBorder.none, // Omogućava normalan border
            filled: true, // Uklanja unutrašnji border
            contentPadding: const EdgeInsets.all(10), // Dodatni razmak od ivica
            fillColor: const Color.fromARGB(255, 240, 240, 240),
          ),
        ),
      ),
    );
  }*/
}
