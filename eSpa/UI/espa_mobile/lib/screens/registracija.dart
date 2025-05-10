import 'dart:convert';
import 'dart:io';
import 'package:espa_mobile/providers/slikaProfila_provider.dart';
import 'package:espa_mobile/screens/login.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../providers/korisnik_provider.dart';

class RegistracijaScreen extends StatefulWidget {
  const RegistracijaScreen({super.key});

  @override
  State<RegistracijaScreen> createState() => _RegistracijaScreenState();
}

class _RegistracijaScreenState extends State<RegistracijaScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  //Uint8List? _image;
  String? _fileName;
  String? _fileType;
  File? _image;
  final _korisnikProvider = KorisnikProvider();
  final _slikaProvider = SlikaProfilaProvider();
  String? imagePath;

  String? _base64image;
  /*
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    print("RESULT SLIKE $result");
    print(
        "BYTES PATH -------------------------------------->${result!.files.single.bytes}");
    imagePath = result.files.single.path!;
    print("IMAGE PATH -------------------->$imagePath");
    if (result != null && result.files.single.bytes != null) {
      File file = File(result.files.single.path!);
      Uint8List fileBytes = await file.readAsBytes();

      print("Bytes dužina: ${fileBytes.length}");
      setState(() {
        _image = result.files.single.bytes;
        print("IMAGE $_image");
        _fileName = result.files.single.name;
        _fileType = result.files.single.extension ?? 'jpg';
      });
    }
  }*/
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    print("RESULT SLIKE $result");
    imagePath = result!.files.single.path!;
    // ignore: unnecessary_null_comparison
    if (result != null && result.files.single.path != null) {
      imagePath = result.files.single.path!;

      setState(() {
        _image = File(imagePath!);
        _base64image = base64Encode(_image!.readAsBytesSync());
        _fileName = result.files.single.name;
        _fileType = result.files.single.extension ?? 'jpg';
        print("IMAGE PATH -------------------->$imagePath");

        print("base64 u buildimapgepicker $_base64image");
      });
      print(
          "${(_image != null && _base64image != null) ? "postoji slika" : "ne postoji slika"}");
    }

    
  }

  Widget _buildInputField(String label, IconData icon, String name,
      {bool obscureText = false}) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Polje je obavezno';
        }

        if (name == "ime" || name == "prezime") {
          if (!RegExp(r'^[A-Za-zšđčćžŠĐČĆŽ]+$').hasMatch(value)) {
            return 'Polje može sadržati samo slova';
          }
          if (value.length < 3) {
            return 'Unesite najmanje 3 karaktera';
          }
          if (!RegExp(r'^[A-ZŠĐČĆŽ]').hasMatch(value)) {
            return 'Prvo slovo mora biti veliko';
          }
        }

        /* if (name == "email") {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Unesite validan email';
          }
        }*/

        if (name == "korisnickoIme") {
          if (value.length <= 3) {
            return 'Korisničko ime mora imati više od 3 karaktera';
          }
          if (!RegExp(r'^[a-z0-9]+$').hasMatch(value)) {
            return 'Može sadržati samo mala slova i brojeve';
          }
        }

        if (name == "password" || name == "passwordPotvrda") {
          if (value.length <= 4) {
            return 'Lozinka mora imati više od 4 karaktera';
          }
        }

        if (name == "passwordPotvrda") {
          String? password = _formKey.currentState?.fields['password']?.value;
          if (password != null && password != value) {
            return 'Lozinke se ne podudaraju';
          }
        }

        if (name == "telefon") {
          if (!RegExp(r'^06\d{7}$').hasMatch(value)) {
            return 'Broj telefona mora počinjati s "06" i imati 9 cifara';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEmailField(String label, IconData icon, String name) {
    return FormBuilderTextField(
      name: name,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email je obavezan';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Unesite ispravan email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        //Text("Image $imagePath"),
        /* _image != null
            ? Image.memory(_image!, height: 100)
            : const Text("Nema slike odabrane"),*/
        _image != null
            ? Image.file(_image!, height: 100)
            : const Text(""),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Dodaj sliku"),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var request = Map<String, dynamic>.from(_formKey.currentState!.value);

      Authorization.username = "proba";
      Authorization.password = "proba";

      try {
        int? slikaId;

        if (_image != null) {
          // String imageBase64 = base64Encode(_image!);
          var slikaRequest = {
            'naziv': _fileName,
            'slikaBase64': _base64image,
            'tip': _fileType,
          };

          var slikaResponse = await _slikaProvider.insert(slikaRequest);
          slikaId = slikaResponse.id;
          print("Slikaid --------------------> $slikaId");
        }

        if (slikaId != null) {
          request['slikaId'] = slikaId;
        }

        var nesto = await _korisnikProvider.insert(request);
        print("NESTO-------------------------------------->$nesto");
        // ignore: unnecessary_null_comparison
        if (nesto != null) {
          Authorization.username = "";
          Authorization.password = "";
        }
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) =>
                false, // Ovdje se koristi `false`, što znači da uklanja sve prethodne ekrane
          );

          // Navigator.pushReplacementNamed(context, '/login');
          /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );*/
        }
      } catch (e) {
        print("GRESKA ${e.toString()}");
        _showErrorDialog("Greška prilikom registracije. Provjerite podatke.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Greška"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registracija")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              _buildInputField("Ime", Icons.person, "ime"),
              const SizedBox(height: 10),
              _buildInputField("Prezime", Icons.person, "prezime"),
              const SizedBox(height: 10),
              // _buildInputField("Email", Icons.email, "email"),
              _buildEmailField("Email", Icons.email, "email"),
              const SizedBox(height: 10),
              _buildInputField("Telefon", Icons.phone, "telefon"),
              const SizedBox(height: 10),
              _buildInputField(
                  "Korisničko ime", Icons.account_circle, "korisnickoIme"),
              const SizedBox(height: 10),
              _buildInputField("Lozinka", Icons.lock, "password",
                  obscureText: true),
              const SizedBox(height: 10),
              _buildInputField("Potvrda lozinke", Icons.lock, "passwordPotvrda",
                  obscureText: true),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Registruj se"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
