import 'dart:convert';

import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/screens/novosti.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NovostDetaljiPage extends StatefulWidget {
  Novost? novost;
  NovostDetaljiPage({Key? key, this.novost}) : super(key: key);

  @override
  State<NovostDetaljiPage> createState() => _NovostDetaljiPageState();
}

class _NovostDetaljiPageState extends State<NovostDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NovostProvider _novostProvider;
  var _image;
  SearchResult<Novost>? novostResult;
  bool isLoading = true;

  bool _isAktivna = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naslov': widget.novost?.naslov,
      'sadrzaj': widget.novost?.sadrzaj,
      'datumKreiranja': widget.novost?.datumKreiranja,
      'korisnickoIme': widget.novost?.autor?.korisnickoIme,
      'status': widget.novost?.status ?? 'Aktivna',
      'slika': widget.novost?.slika,
    };
    _isAktivna = _initialValue['status'] == 'Aktivna';
    _novostProvider = context.read<NovostProvider>();

    initForm();
    print("status $_initialValue");
  }

  Future initForm() async {
    novostResult = await _novostProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildStatusSwitch() {
    return SwitchListTile(
      title: Text("Status: ${_isAktivna ? 'Aktivna' : 'Neaktivna'}"),
      value: _isAktivna,
      onChanged: (bool value) {
        setState(() {
          _isAktivna = value;
          _initialValue['status'] = value ? 'Aktivna' : 'Neaktivna';
        });
      },
      secondary: Icon(Icons.check_circle),
    );
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
          'Unknown'; // Sprema odabranu sliku u memoriju
        });
        //print("✅ Slika odabrana!");
      } else {
        // print("❌ Nema izabrane slike");
      }
    } catch (e) {
      //print("❌ Greška pri odabiru slike: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0), // Odmicanje od ivica ekrana
          child: Container(
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Sprečava prekomjerno širenje
                children: [
                  // Red sa naslovom i X dugmetom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(), // Gura dugme skroz desno
                      IconButton(
                        icon: Icon(Icons.close, color: Color.fromARGB(137, 108, 107, 107)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  isLoading ? const CircularProgressIndicator() : _buildForm(),
                  const SizedBox(height: 20),

                  // Dugmad za navigaciju
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NovostPage()),
                          );
                        },
                        child: const Text("Nazad"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!(_formKey.currentState?.saveAndValidate() ??
                              false)) {
                            print("Validacija nije prošla!");
                            return;
                          }
                          var request = Map.from(_formKey.currentState!.value);
                          var currentValues =
                              Map.from(_formKey.currentState!.value);

                          request['status'] =
                              _isAktivna ? 'Aktivna' : 'Neaktivna'; // ← dodano
                          if (_image != null) {
                            String imageBase64 = base64Encode(_image!);
                            request['slikaBase64'] = imageBase64;
                          }

                          bool isChanged = false;
                          print("Initial Values: $_initialValue");
                          print("Current Values: $currentValues");
                          _initialValue.forEach((key, value) {
                            if (currentValues[key] != value) {
                              isChanged = true;
                            }
                          });

                          if (!isChanged) {
                            Navigator.pop(context, false);
                            return;
                          }

                          try {
                            if (widget.novost == null) {
                              await _novostProvider.insert(request);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Novost uspješno dodana.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              await _novostProvider.update(
                                  widget.novost!.id!, request);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Novost uspješno modifikovana.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NovostPage()),
                            );
                          } on Exception catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text("Sačuvaj"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      title: /*this.widget.novost?.naslov ??*/ "Novost detalji",
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
          _buildInputField("Naslov", Icons.title, "naslov"),
          SizedBox(height: 10),
          _buildInputField1("Sadrzaj", Icons.description, "sadrzaj"),
          SizedBox(height: 10),
          /*_buildStatusDropdownField(
              "Status", "status"),*/ // Ovdje koristiš novi dropdown
          _buildStatusSwitch(),
          SizedBox(height: 10),
          _buildImagePicker(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

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
              : widget.novost?.slika != null && widget.novost!.slika!.isNotEmpty
                  ? Image.memory(
                      base64Decode(widget.novost!.slika!),
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
        // Provera da li je prvo slovo veliko
        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
          return 'Prvo slovo mora biti veliko';
        }
        if (value.length <= 3) {
          return 'Unesite više od 3 karaktera';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdownField(String label, String name) {
    // Provjeri da li je novost null, što znači da se kreira nova novost
    if (widget.novost == null) {
      // Ako je nova novost, ne prikazuj status
      return SizedBox.shrink(); // Vraća prazni widget (ne prikazuje ništa)
    }

    // Ako nije nova novost, prikaži status dropdown
    return FormBuilderDropdown<String>(
      name: name,
      initialValue: _initialValue[name] ??
          "Aktivna", // Podrazumevana vrijednost za ažuriranje
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(Icons.check_circle_outline), // Ikona pored dropdown menija
        border: OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem<String>(
          value: "Aktivna",
          child: Text("Aktivna"),
        ),
        DropdownMenuItem<String>(
          value: "Neaktivna",
          child: Text("Neaktivna"),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _initialValue[name] =
              value; // Ažuriraj status kada se odabere nova vrednost
        });
      },
    );
  }

  Widget _buildInputField1(String label, IconData icon, String name) {
    return FormBuilderTextField(
      name: name,
      minLines: 1, // Početna visina polja
      maxLines: 3, // Omogućava beskonačno širenje prema dole
      keyboardType: TextInputType.multiline, // Omogućava unos više linija
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Polje je obavezno';
        }
        // Provera da li je prvo slovo veliko
        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
          return 'Prvo slovo mora biti veliko';
        }
        // Provera minimalne dužine (više od 10 karaktera)
        if (value.length <= 10) {
          return 'Unesite više od 10 karaktera';
        }
        return null;
      },
    );
  }
}
