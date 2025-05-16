import 'package:espa_admin/models/komentar.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/komentar_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecenzijaDetaljiPage extends StatefulWidget {
  final Komentar? komentar;
  const RecenzijaDetaljiPage({Key? key, this.komentar}) : super(key: key);

  @override
  State<RecenzijaDetaljiPage> createState() => _RecenzijaDetaljiPageState();
}

class _RecenzijaDetaljiPageState extends State<RecenzijaDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KomentarProvider _komentarProvider;
  SearchResult<Komentar>? komentarResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'korisnik': widget.komentar?.korisnik?.korisnickoIme,
      'usluga': widget.komentar?.usluga?.naziv,
      'tekst': widget.komentar?.tekst,
      'datum': widget.komentar?.datum,
    };

    _komentarProvider = context.read<KomentarProvider>();
    initForm();
  }

  Future initForm() async {
    komentarResult = await _komentarProvider.get();
    setState(() {
      isLoading = false;
    });
  }


  
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.komentar?.korisnik?.korisnickoIme ?? "Recenzija detalji",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(160.0),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(), // Gura dugme skroz desno
                              IconButton(
                                icon: Icon(Icons.close, color: Color.fromARGB(137, 104, 102, 102)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          _buildForm(),
                          const SizedBox(height: 20),
                          _buildBackButton(), // Dugme za nazad
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

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          _buildDisabledField(
              "Korisnik", "korisnik", _initialValue['korisnik']),
          const SizedBox(height: 10),
          _buildDisabledField("Usluga", "usluga", _initialValue['usluga']),
          const SizedBox(height: 10),
          _buildDisabledField3("Tekst", "tekst", _initialValue['tekst']),
          const SizedBox(height: 10),
          //_buildDisabledField("Datum", "datum", _initialValue['datum']?.toString()),
          _buildDisabledField(
              "Datum",
              "datum",
              _initialValue['datum'] != null
                  ? DateFormat('d.M.yyyy')
                      .format(DateTime.parse(_initialValue['datum'].toString()))
                  : ''),
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
      ),
    );
  }
  


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
            const AlwaysScrollableScrollPhysics(), // Osigurava da skrol uvijek bude dostupan
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
  }
}
