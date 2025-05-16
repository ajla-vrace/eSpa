import 'dart:convert';
import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/uloga.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/providers/korisnikUloga_provider.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/providers/slikaProfila_provider.dart';
import 'package:espa_admin/providers/uloga_provider.dart';
//import 'package:espa_admin/providers/zaposlenikSlike_provider.dart';
import 'package:espa_admin/providers/zaposlenik_provider.dart';
import 'package:espa_admin/screens/zaposlenici.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class ZaposlenikDetaljiPage extends StatefulWidget {
  @override
  _ZaposlenikDetaljiPageState createState() => _ZaposlenikDetaljiPageState();
}

class _ZaposlenikDetaljiPageState extends State<ZaposlenikDetaljiPage> {
  final _formKeyKorisnik = GlobalKey<FormBuilderState>();
  final _formKeyZaposlenik = GlobalKey<FormBuilderState>();

  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;
  late KorisnikUlogaProvider _korisnikUlogaProvider;
  late ZaposlenikProvider _zaposlenikProvider;
  late KategorijaProvider _kategorijaProvider;
  //late ZaposlenikSlikeProvider _zaposlenikSlikeProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;

  int? korisnikId;
  bool korisnikKreiran = false;
  final FocusNode strukaFocusNode = FocusNode();
  var _image;

  String? _fileName;

  String? _fileType;

  int? selectedUlogaId;

  var uloge;
  SearchResult<Uloga>? ulogaResult;

  int? selectedKategorijaId;

  List<Kategorija>? kategorije = [];
//final ImagePicker _picker = ImagePicker();

  //bool _isFormValid = false;

  @override
  void initState() {
    super
        .initState(); /*if (_formKeyKorisnik.currentState?.saveAndValidate() ?? false) { 
  // Izvrši akciju
}*/

    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _korisnikUlogaProvider = context.read<KorisnikUlogaProvider>();
    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    _kategorijaProvider = context.read<KategorijaProvider>();
    //_zaposlenikSlikeProvider = context.read<ZaposlenikSlikeProvider>();
    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();
    loadUlogaData();
    loadUslugeData();
    loadKategorije();
  }


  Future<void> loadUlogaData() async {
    try {
      final ulogeResult = await _ulogaProvider.get();
      print("uloge: $ulogeResult");
      var samoUloge = ulogeResult.result;
      uloge = samoUloge; // Ispisivanje korisnika
      List<Uloga> filteredRoles = samoUloge
          .where((role) => role.naziv?.toLowerCase() != 'administrator')
          .toList();
      // Ako korisnik ima ulogu, uzimamo ID njegove ul
      selectedUlogaId = selectedUlogaId = filteredRoles.first.id;
      print("odabrana selcetdulogaid je $selectedUlogaId");
      // Ako nema ulogu, uzimamo defaultnu ulogu (prva uloga iz liste koja nije 'administrator')
    } catch (e) {
      print("Greška pri učitavanju podataka o korisniku: $e");
    }
  }

  Future<void> loadKategorije() async {
    try {
      final kategorijeResult = await _kategorijaProvider.get();
      print("uloge: $kategorijeResult");
      kategorije = kategorijeResult.result;
      // Ispisivanje korisnika

      // Ako korisnik ima ulogu, uzimamo ID njegove ul
      if (kategorije != null && kategorije != []) {
        selectedKategorijaId = /*selectedUlogaId =*/ kategorije!.first.id;
      }
      print("odabrana selectedkategorijaid $selectedKategorijaId");
      // Ako nema ulogu, uzimamo defaultnu ulogu (prva uloga iz liste koja nije 'administrator')
    } catch (e) {
      print("Greška pri učitavanju podataka o korisniku: $e");
    }
  }

  Future<void> loadUslugeData() async {
    try {
      // Učitaj korisnika putem ID-a
      //  ulogeResult = await _ulogaProvider.get();
      print("uloge: $uloge");

      // Pronađi ID uloge korisnika u listi dostupnih uloga
    } catch (e) {
      print("Greška pri učitavanju podataka o uloge: $e");
    }
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
          _fileName = result.files.single.name;
          _fileType = result.files.single.extension ??
              'Unknown'; // Spremamo odabranu sliku u memoriju
        });
       // print("✅ Slika odabrana!");
      } else {
       // print("❌ Nema izabrane slike");
      }
    } catch (e) {
     // print("❌ Greška pri odabiru slike: $e");
    }
  }

/*
  Future<List<int>> _imageToBytes(File image) async {
    return await image.readAsBytes();
  }*/

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: korisnikKreiran ? "Dodaj Zaposlenika" : "Dodaj Korisnika",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 400,
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
            child:
                korisnikKreiran ? _buildZaposlenikForm() : _buildKorisnikForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildKorisnikForm() {
    return SingleChildScrollView(
      // Omotavanje forme u SingleChildScrollView
      child: FormBuilder(
        key: _formKeyKorisnik,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* Text(
                        widget.novost?.naslov ?? "Novost details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),*/
                Spacer(), // Gura dugme skroz desno
                IconButton(
                  icon: Icon(Icons.close, color: Color.fromARGB(137, 88, 86, 86)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            _buildInputField("Ime", Icons.person, "ime"),
            SizedBox(height: 10),
            _buildInputField("Prezime", Icons.person, "prezime"),
            SizedBox(height: 10),
            _buildInputField("Email", Icons.email, "email"),
            SizedBox(height: 10),
            _buildInputFieldTelefon("Broj telefona", Icons.phone, "telefon"),
            SizedBox(height: 10),
            _buildInputField(
                "Korisničko ime", Icons.account_circle, "korisnickoIme"),
            SizedBox(height: 10),
            _buildInputField("Lozinka", Icons.lock, "password",
                obscureText: true),
            SizedBox(height: 10),
            _buildInputField("Potvrda lozinke", Icons.lock, "passwordPotvrda",
                obscureText: true),
            SizedBox(height: 20),
            _buildImagePicker(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ZaposlenikPage()),
                    );
                  },
                  child: const Text("Nazad"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKeyKorisnik.currentState?.saveAndValidate() ??
                        false) {
                      var request = Map<String, dynamic>.from(
                          _formKeyKorisnik.currentState!.value);

                      request['korisnikId'] = korisnikId;

                      try {
                        int? slikaIdKorisnik;
                        print(
                            "slikaidkorisnik: $slikaIdKorisnik"); // Varijabla za sliku ID
                        print("image: $_image");
                        // Ako postoji slika, prvo je dodaj u ZaposlenikSlike tabelu
                        if (_image != null) {
                          print(" u ifu image!=null");
                          // Konvertovanje slike u bajtove
                          /*List<int> imageBytes = await _imageToBytes(_image!);
                    String imageBase64 = base64Encode(imageBytes);*/
                          String imageBase64 = base64Encode(_image!);
                          print("imagebas64 : $imageBase64");
                          // Kreiranje objekta za sliku
                          var slikaRequest = {
                            'naziv': _fileName,
                            'slikaBase64': imageBase64,
                            'tip': _fileType,
                          };

                          // Dodaj sliku u tabelu ZaposlenikSlike
                          var slikaResponse =
                              await _slikaProfilaProvider.insert(slikaRequest);
                          print(slikaResponse.slika);
                          // Ako je slika uspešno dodana, dobijamo SlikaId
                          slikaIdKorisnik = slikaResponse.id;
                          print("slikakorisnikaid: $slikaIdKorisnik");
                        }

                        if (slikaIdKorisnik != null) {
                          print("u ifu je li idslike null");
                          request['slikaId'] = slikaIdKorisnik;
                        }

                        Korisnik kreiraniKorisnik =
                            await _korisnikProvider.insert(request);
                        setState(() {
                          korisnikId = kreiraniKorisnik.id;
                          print("kreirani korisnik $kreiraniKorisnik");
                          korisnikKreiran = true;
                        });
                      } catch (e) {
                        print("show error dialog OVDEJEE");
                        // _showErrorDialog(e.toString());
                        _showErrorDialog(
                            "Desila se greska prilikom kreiranja korisnika. Email ili korisnicko ime je vec u upotrebi.");
                      }
                    }
                  },
                  child: Text("Sačuvaj Korisnika"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildZaposlenikForm() {
    return FormBuilder(
      key: _formKeyZaposlenik,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        // Dodaj ovo za omogućavanje scrolliranja
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* Text(
                        widget.novost?.naslov ?? "Novost details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),*/
                Spacer(), // Gura dugme skroz desno
                IconButton(
                  icon: Icon(Icons.close, color: Color.fromARGB(137, 85, 82, 82)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            _buildDatePicker("Datum zaposlenja", "datumZaposlenja"),
            SizedBox(height: 10),
            _buildInputFieldStruka(),
            SizedBox(height: 10),
            /* _buildDropdownField("Status", Icons.check_circle, "status"),
            SizedBox(height: 10),*/
            _buildInputFieldNapomena("Napomena", Icons.notes, "napomena"),
            SizedBox(height: 10),
            _buildInputField1("Biografija", Icons.description, "biografija"),
            SizedBox(height: 10),
            /* _buildRoleDropdown(),
            SizedBox(
              height: 10,
            ),*/
            SizedBox(height: 10),
            _buildKategorijaDropdown(),
             SizedBox(height: 20),

            //_buildImagePicker(),
            //SizedBox(height: 10),

           

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _korisnikProvider.delete(korisnikId!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ZaposlenikPage()),
                    );
                  },
                  child: const Text("Nazad"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKeyZaposlenik.currentState?.saveAndValidate() ??
                        false) {
                      var request = Map<String, dynamic>.from(
                          _formKeyZaposlenik.currentState!.value);

                      // Provera i konverzija datuma u String format (YYYY-MM-DD)
                      if (request.containsKey('datumZaposlenja') &&
                          request['datumZaposlenja'] is DateTime) {
                        request['datumZaposlenja'] =
                            (request['datumZaposlenja'] as DateTime)
                                .toIso8601String();
                      }

                      // Kreiranje zaposlenika (bez slike)
                      request['korisnikId'] = korisnikId;

                      try {
                       

                        print(request);
                        // Kreiraj zaposlenika sa ili bez SlikaId
                        /* var zaposlenikResponse =*/
                        await _zaposlenikProvider.insert(request);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Zaposlenik uspješno dodan.",
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
                        // Navigacija nakon uspešnog dodavanja zaposlenika
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ZaposlenikPage(),
                          ),
                        );
                      } catch (e) {
                        _showErrorDialog(e.toString());
                      }
                    }
                  },
                  child: Text("Sačuvaj Zaposlenika"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    // Filtriraj uloge koje nisu 'admin'

    List<Uloga> filteredRoles = uloge
        .where((role) => role.naziv.toLowerCase() != 'administrator')
        .toList();
    // Provera da li postoji dodeljena uloga za zaposlenika

    print("selectedUlogaId: $selectedUlogaId");

    print("selectedUlogaId: $selectedUlogaId");

    //print("filtered roles $filteredRoles");
    print("default selectedUlogaId $selectedUlogaId");
    return FormBuilderDropdown<int>(
      name: "ulogaId",
      initialValue: selectedUlogaId, // Postavljamo defaultnu vrijednost
      decoration: InputDecoration(
        labelText: "Uloga",
        prefixIcon: Icon(Icons.group),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Odaberite ulogu';
        }
        return null;
      },
      items: filteredRoles.map((role) {
        return DropdownMenuItem<int>(
          value: role.id,
          child: Text(role.naziv.toString()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          print("selected u setstate $selectedUlogaId");
          print("value $value");
          // Ovdje pohranjuješ selektovanu ulogu
          selectedUlogaId = value;
          print("selected u setstate poslije $selectedUlogaId");
          print("value $value");
        });
      },
    );
  }

  Widget _buildKategorijaDropdown() {
    // Filtriraj kategorije, postavi defaultnu vrijednost
    List<Kategorija> filteredCategories =
        kategorije!; // Ovo pretpostavljamo da su kategorije učitane.

    return FormBuilderDropdown<int>(
      name: "kategorijaId",
      initialValue: selectedKategorijaId ??
          filteredCategories.first.id, // Prva kategorija kao default
      decoration: const InputDecoration(
        labelText: "Kategorija",
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Odaberite kategoriju';
        }
        return null;
      },
      items: filteredCategories.map((kategorija) {
        return DropdownMenuItem<int>(
          value: kategorija.id,
          child: Text(kategorija.naziv!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedKategorijaId = value;
          print("Nova selektovana kategorija: $selectedKategorijaId");
        });
      },
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await _pickImage(); // Funkcija za odabir slike
          },
          child: _image != null
              ? Image.memory(
                  _image!, // Prikazivanje odabrane slike
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.camera_alt,
                  size: 100,
                  color: Colors
                      .grey), // Prikaz ikone kamere ako slika nije odabrana
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await _pickImage(); // Ponovno odabir slike
          },
          child: const Text("Dodaj sliku"),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    String name, {
    bool obscureText = false,
    /*bool multiline = false*/
  }) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      validator: (value) {
        /* if (value == null || value.isEmpty && name != "napomena") {
          return 'Polje je obavezno';
        }*/
        if (value == null || (value.isEmpty && name != "napomena")) {
          return 'Polje je obavezno';
        }
        if (name == "ime" || name == "prezime") {
          // Provera da li je ime/prezime minimalno 3 karaktera, samo slova, i prvo slovo veliko
          if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) {
            return 'Polje može sadržati samo slova';
          }
          if (value.length < 3) {
            return 'Unesite najmanje 3 karaktera';
          }
          if (!RegExp(r'^[A-Z]').hasMatch(value)) {
            return 'Prvo slovo mora biti veliko';
          }
        }

        if (name == "email") {
          // Validacija za email
          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value)) {
            return 'Unesite validan email';
          }
        }

        if (name == "korisnickoIme") {
          // Validacija za korisničko ime (samo mala slova i brojevi)
          if (value.length <= 3) {
            return 'Korisnicko ime mora imati više od 3 karaktera';
          }
          if (!RegExp(r'^[a-z0-9]+$').hasMatch(value)) {
            return 'Korisničko ime može sadržavati samo mala slova i brojeve';
          }
        }

        if (name == "password" || name == "passwordPotvrda") {
          // Validacija za lozinku (više od 4 karaktera)
          if (value.length <= 3) {
            return 'Lozinka mora imati min 4 karaktera';
          }
        }
        if (name == "passwordPotvrda") {
          // Provjera da li se lozinke podudaraju
          String? password =
              _formKeyKorisnik.currentState?.fields['password']?.value;
          if (password != null && password != value) {
            return 'Lozinke se ne podudaraju';
          }
        }
        if (name == "telefon") {
          if (!RegExp(r'^06\d{7}$').hasMatch(value)) {
            return 'Broj telefona mora počinjati s "06" i imati 9 cifara"';
          }
        }

        return null; // Ako je validacija prošla, vraća null
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      //maxLines: multiline ? null : 1,
    );
  }


Widget _buildInputFieldTelefon(
    String label,
    IconData icon,
    String name, {
    bool obscureText = false,
    /*bool multiline = false*/
  }) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || (value.isEmpty && name != "napomena")) {
          return 'Polje je obavezno';
        }
        
        
        if (name == "telefon") {
          if (!RegExp(r'^06\d{7}$').hasMatch(value)) {
            return 'Broj telefona mora počinjati s "06" i imati 9 cifara"';
          }
        }

        return null; // Ako je validacija prošla, vraća null
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Format 06xxxxxxx',
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      //maxLines: multiline ? null : 1,
    );
  }




  Widget _buildInputField1(String label, IconData icon, String name,
      {bool required = true}) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Polje je obavezno';
        }

        if (name == "struka") {
          // Ako nije prazno, provjeri validaciju
          if (value != null && value.isNotEmpty) {
            // Provera da li počinje velikim slovom
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Struka mora početi velikim slovom';
            }
            // Provera minimalne dužine
            if (value.length < 3) {
              return 'Struka mora imati najmanje 3 slova';
            }
            // Provera da li sadrži samo slova
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž][A-ZČĆĐŠŽa-zčćđšž. ]*$')
                .hasMatch(value)) {
              return 'Struka može sadržavati samo slova.';
            }
          }
        } else if (name == "biografija") {
          // Ako nije prazno, provjeri validaciju
          if (value != null && value.isNotEmpty) {
            // Provera da li počinje velikim slovom
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Biografija mora početi velikim slovom';
            }
            // Provera minimalne dužine
            if (value.length < 3) {
              return 'Biografija mora imati najmanje 3 karaktera';
            }
          }
        }

        return null;
      },
    );
  }

  Widget _buildInputFieldNapomena(String label, IconData icon, String name,
      {bool required = false}) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return null;
        }

        if (name == "napomena") {
          // Ako nije prazno, provjeri validaciju
          if (value != null && value.isNotEmpty) {
            // Provera da li počinje velikim slovom
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Napomena mora početi velikim slovom';
            }
            // Provera minimalne dužine
            if (value.length < 3) {
              return 'Struka mora imati najmanje 3 slova';
            }
            // Provera da li sadrži samo slova
          }
        }

        return null;
      },
    );
  }

  Widget _buildInputFieldStruka() {
    return FormBuilderTextField(
      name: "struka",
      focusNode: strukaFocusNode, // Fokus prebacujemo sa DatePicker-a
      decoration: InputDecoration(
        labelText: "Struka",
        prefixIcon: Icon(Icons.work), // Dodana ikonica
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.sentences, // Početno slovo veliko
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Polje je obavezno';
        }
        if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
          return 'Struka mora početi velikim slovom';
        }
        if (value.length < 3) {
          return 'Struka mora imati najmanje 3 slova';
        }
        if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž][A-ZČĆĐŠŽa-zčćđšž. ]*$')
            .hasMatch(value)) {
          return 'Struka može sadržavati samo slova.';
        }

        return null;
      },
    );
  }

  Widget _buildDatePicker(String label, String name) {
    return FormBuilderDateTimePicker(
      name: name,
      inputType: InputType.date,
      format: DateFormat("dd.MM.yyyy"),
      lastDate: DateTime.now(), // Onemogućava buduće datume
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today), // Ikona sa leve strane
      ),
      validator: (value) {
        if (value == null) {
          return "Odaberite datum zaposlenja";
        }
        if (value.isAfter(DateTime.now())) {
          return "Datum ne može biti u budućnosti";
        }
        return null;
      },
      onChanged: (value) {
        // Kada korisnik odabere datum, fokusiraj polje Struka
        FocusScope.of(context).requestFocus(strukaFocusNode);
      },
    );
  }

  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Greška"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
