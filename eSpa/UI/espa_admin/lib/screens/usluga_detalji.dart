import 'dart:convert';

import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/usluga.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/screens/usluge.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UslugaDetaljiPage extends StatefulWidget {
  Usluga? usluga;
  UslugaDetaljiPage({Key? key, this.usluga}) : super(key: key);

  @override
  State<UslugaDetaljiPage> createState() => _UslugaDetaljiPageState();
}

class _UslugaDetaljiPageState extends State<UslugaDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KategorijaProvider _kategorijaProvider;
  late UslugaProvider _uslugaProvider;
  var _image;
  SearchResult<Kategorija>? kategorijaResult;
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
      'kategorija': widget.usluga?.kategorija,
    };

    _kategorijaProvider = context.read<KategorijaProvider>();
    _uslugaProvider = context.read<UslugaProvider>();

    initForm();
  }

  Future initForm() async {
    kategorijaResult = await _kategorijaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null) {
        setState(() {
          _image = result.files.single.bytes;
          //_fileName = result.files.single.name;
          //_fileType = result.files.single.extension ??
          'Unknown'; // Spremamo odabranu sliku u memoriju
        });
        print("✅ Slika odabrana!");
      } else {
        print("❌ Nema izabrane slike");
      }
    } catch (e) {
      print("❌ Greška pri odabiru slike: $e");
    }
  }
/*
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Center(
        child: Container(
          width: 500,  // Pravougaonik u sredini ekrana
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              isLoading ? CircularProgressIndicator() : _buildForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.saveAndValidate();
                        var request = new Map.from(_formKey.currentState!.value);

                        try {
                          if (widget.usluga == null) {
                            await _uslugaProvider.insert(request);
                          } else {
                            await _uslugaProvider.update(widget.usluga!.id!, request);
                          }
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Error"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text("Sačuvaj"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      title: this.widget.usluga?.naziv ?? "Usluga details",
    );
  }
*/

/*
@override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0), // Odmicanje od ivica ekrana
          child: Container(
            width: 500, 
           // height: 500, // Pravougaonik u sredini ekrana
            padding: EdgeInsets.all(20),
            //margin: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                isLoading ? CircularProgressIndicator() : _buildForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.saveAndValidate();
                          var request = new Map.from(_formKey.currentState!.value);

                          try {
                            if (widget.usluga == null) {
                              await _uslugaProvider.insert(request);
                            } else {
                              await _uslugaProvider.update(widget.usluga!.id!, request);
                            }
                          } on Exception catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Sačuvaj"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      title: this.widget.usluga?.naziv ?? "Usluga details",
    );
  }

*/

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // Ostatak sadržaja dolazi iz MasterScreenWidget-a
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0), // Odmicanje od ivica ekrana

          child: Container(
            width: 500,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black54),
                      onPressed: () {
                        Navigator.pop(context); // Zatvara stranicu
                      },
                    ),
                  ),
                  isLoading ? CircularProgressIndicator() : _buildForm(),
                  SizedBox(
                      height: 20), // Dodavanje prostora između forme i dugmeta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Dugme "Nazad"
                        },
                        child: Text("Nazad"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.saveAndValidate();
                          if (!(_formKey.currentState?.saveAndValidate() ??
                              false)) {
                            // Možeš prikazati poruku korisniku ako je potrebno
                            print("Validacija nije prošla!");
                            return;
                          }
                          var request =
                              new Map.from(_formKey.currentState!.value);

                          var currentValues =
                              Map.from(_formKey.currentState!.value);

                          if (_image != null) {
                            String imageBase64 = base64Encode(_image!);
                            request['slikaBase64'] = imageBase64;
                          }

                          // Provera da li su vrednosti promenjene
                          bool isChanged = false;
                          _initialValue.forEach((key, value) {
                            if (currentValues[key] != value) {
                              isChanged = true;
                            }
                          });

                          if (!isChanged) {
                            // Ako nema promena, vrati se na prethodnu stranicu bez ažuriranja
                            Navigator.pop(context, false);
                            return;
                          }

                          try {
                            if (widget.usluga == null) {
                              await _uslugaProvider.insert(request);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Usluga uspješno dodana.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      Colors.green, // Dodaj zelenu pozadinu
                                  behavior: SnackBarBehavior
                                      .floating, // Opcionalno za lepši prikaz
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              await _uslugaProvider.update(
                                  widget.usluga!.id!, request);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Usluga uspješno modifikovana.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      Colors.green, // Dodaj zelenu pozadinu
                                  behavior: SnackBarBehavior
                                      .floating, // Opcionalno za lepši prikaz
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UslugaPage(),
                              ),
                            );
                          // ignore: unused_catch_clause
                          } on Exception catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: /*Text(e.toString())*/Text("Usluga s ovim nazivom vec postoji."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Sačuvaj"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: this.widget.usluga?.naziv ?? "Usluga details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Polja sa ikonama
          _buildInputField("Naziv", Icons.title, "naziv"),
          SizedBox(height: 10),
          _buildInputField("Opis", Icons.description, "opis"),

          SizedBox(height: 10),
          _buildInputField("Cijena", Icons.attach_money, "cijena"),
          SizedBox(height: 10),
          _buildInputField("Trajanje (min)", Icons.access_time,
              "trajanje"), // Dodano trajanje
          SizedBox(height: 10),
          _buildDropdownField(
            "Kategorija",
            Icons.list,
            "kategorijaId",
            kategorijaResult?.result ?? [],
          ),
            SizedBox(height: 5),
          _buildImagePicker(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Funkcija za kreiranje input polja sa ikonom
  /*Widget _buildInputField(String label, IconData icon, String name) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }*/
 Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await _pickImage();
          },
          child: _image != null
              ? Image.memory(
                  _image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : widget.usluga?.slika != null && widget.usluga!.slika!.isNotEmpty
                  ? Image.memory(
                      base64Decode(widget.usluga!.slika!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await _pickImage();
          },
          child: const Text("Dodaj sliku"),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, IconData icon, String name) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Polje je obavezno';
        }

        if (name == "naziv" || name == "opis") {
          if (!RegExp(r'^[A-Z]').hasMatch(value)) {
            return 'Prvo slovo mora biti veliko';
          }
        }

        if (name == "cijena" || name == "trajanje") {
          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Dozvoljeni su samo brojevi';
          }
          int broj = int.parse(value);
          if (name == "cijena" && (broj < 10 || broj > 500)) {
            return 'Cijena mora biti između 10 i 500';
          }
          if (name == "trajanje" && (broj < 40 || broj > 50)) {
            return 'Trajanje mora biti između 40 i 50 minuta';
          }
        }

        return null;
      },
      keyboardType: (name == "cijena" || name == "trajanje")
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  // Funkcija za dropdown meni sa kategorijama
  /*Widget _buildDropdownField(
    String label,
    IconData icon,
    String name,
    List<Kategorija> items,
  ) {
    return FormBuilderDropdown<String>(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item.id.toString(),
                child: Text(item.naziv ?? ""),
              ))
          .toList(),
    );
  }*/
  Widget _buildDropdownField(
    String label,
    IconData icon,
    String name,
    List<Kategorija> items,
  ) {
    return FormBuilderDropdown<String>(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Morate odabrati kategoriju";
        }
        return null;
      },
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item.id.toString(),
                child: Text(item.naziv ?? ""),
              ))
          .toList(),
    );
  }
}
