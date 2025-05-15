import 'dart:convert';
import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/uloga.dart';
import 'package:espa_admin/models/zaposlenik.dart';
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

// ignore: must_be_immutable
class ZaposlenikEditPage extends StatefulWidget {
  Zaposlenik? zaposlenik;
  ZaposlenikEditPage({Key? key, this.zaposlenik}) : super(key: key);

  @override
  State<ZaposlenikEditPage> createState() => _ZaposlenikEditPageState();
}

class _ZaposlenikEditPageState extends State<ZaposlenikEditPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ZaposlenikProvider _zaposlenikProvider;
  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;
  late KategorijaProvider _kategorijaProvider;
  late KorisnikUlogaProvider _korisnikUlogaProvider;
  //late ZaposlenikSlikeProvider _zaposlenikSlikeProvider;
  late SlikaProfilaProvider _slikaProfilaProvider;
  var slikaID;
  SearchResult<Zaposlenik>? zaposlenikResult;
  var uloge;
  SearchResult<Uloga>? ulogaResult;
  bool isLoading = true;
  var _selectedImageBytes;

  String? fileName;

  int? selectedUlogaId;

  var zaposlenik1;
  List<Kategorija> _kategorije = [];
  int? _selectedKategorijaId;

  //var _defaultUlogaId;

  Future<void> _loadUloga() async {
    if (widget.zaposlenik != null && widget.zaposlenik!.korisnik != null) {
      if (widget.zaposlenik!.korisnik!.korisnikUlogas.isNotEmpty) {
        selectedUlogaId =
            widget.zaposlenik!.korisnik!.korisnikUlogas[0].ulogaId;
        print("loaduloga $selectedUlogaId");
      }
    }
  }

  Future<void> loadKategorije() async {
    var result = await _kategorijaProvider.get();

    setState(() {
      _kategorije = result.result;

      // Postavi odabranu kategoriju iz zaposlenika ako postoji
      if (widget.zaposlenik != null &&
          widget.zaposlenik!.kategorijaId != null) {
        _selectedKategorijaId = widget.zaposlenik!.kategorijaId;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.zaposlenik?.korisnik?.ime,
      'prezime': widget.zaposlenik?.korisnik?.prezime,
      'datumZaposlenja': widget.zaposlenik?.datumZaposlenja,
      'struka': widget.zaposlenik?.struka,
      'status': widget.zaposlenik?.status,
      'napomena': widget.zaposlenik?.napomena,
      'biografija': widget.zaposlenik?.biografija,
      'slikaId': widget.zaposlenik?.slikaId,
      'kategorijaId':widget.zaposlenik!.kategorija!.id,
      //'slika': widget.zaposlenik!.korisnik?.slika!,
      //'korisnikUlogas': widget.zaposlenik?.korisnik?.korisnikUlogas,
    };
    print("initial value u init state: $_initialValue");

    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    //_zaposlenikSlikeProvider = context.read<ZaposlenikSlikeProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _korisnikUlogaProvider = context.read<KorisnikUlogaProvider>();
    _kategorijaProvider = context.read<KategorijaProvider>();
    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();
    initForm();
    loadUslugeData();
    _loadUloga();
    loadKategorije();
    loadKorisnikData(widget.zaposlenik!.korisnikId!);

    /* loadUslugeData().then((_) {
    loadKategorije(); // poziv nakon što se učita zaposlenik
  });*/

    //print("status $_initialValue");

    print("✅ Postavljena podrazumjevana uloga: $selectedUlogaId");
    //setState(() {});
  }

  Future<void> loadUslugeData() async {
    try {
      // Učitaj korisnika putem ID-a
      final uloge = await _ulogaProvider.get();
      print("uloge: $uloge");

      // Pronađi ID uloge korisnika u listi dostupnih uloga
    } catch (e) {
      print("Greška pri učitavanju podataka o uloge: $e");
    }
  }

  Future<void> loadKorisnikData(int korisnikId) async {
    try {
      final uloge = await _ulogaProvider.get();
      // print("uloge: $uloge");
      var samoUloge = uloge.result;
      final korisnik = await _korisnikProvider.getById(korisnikId);
      print("korisnik: $korisnik"); // Ispisivanje korisnika

      // Ako korisnik ima ulogu, uzimamo ID njegove uloge
      final korisnikUlogaId = korisnik.korisnikUlogas.isNotEmpty
          ? korisnik.korisnikUlogas.first.ulogaId
          : null; // Ako nema ulogu, vraćamo null
      print("korisnikulogaid je sada $korisnikUlogaId");

      // Ako nema ulogu, uzimamo defaultnu ulogu (prva uloga iz liste koja nije 'administrator')
      if (korisnikUlogaId == null) {
        List<Uloga> filteredRoles = samoUloge
            .where((role) => role.naziv?.toLowerCase() != 'administrator')
            .toList();
        //print("filteredrolesssssss $filteredRoles");

        // Ako lista nije prazna, uzimamo prvi ID iz filteredRoles
        if (filteredRoles.isNotEmpty) {
          selectedUlogaId = filteredRoles.first.id;
        } else {
          selectedUlogaId = null; // Ako nema validnih uloga, postavi null
        }
      } else {
        selectedUlogaId = korisnikUlogaId;
      }

      print("selectedUlogaId: $selectedUlogaId");

      setState(() {
        // Ažuriramo selectedUlogaId na UI
      });
    } catch (e) {
      print("Greška pri učitavanju podataka o korisniku: $e");
    }
  }

// Funkcija koja uzima ID uloge na temelju id-a korisnika
  /* int? _findUlogaId(int korisnikUlogaId) {
    // Proverite da li lista uloga nije null i nije prazna
    if (uloge != null && uloge.isNotEmpty) {
      var uloga = uloge.firstWhere(
        (role) => role.id == korisnikUlogaId,
        orElse: () => null, // Kada nema odgovarajuće uloge, vrati null
      );

      return uloga != null ? uloga.id : null; // Ako je uloga null, vrati null
    } else {
      // Ako je lista uloga null ili prazna, vrati null
      return null;
    }
  }*/

  Future initForm() async {
    zaposlenikResult = await _zaposlenikProvider.get();
    ulogaResult = await _ulogaProvider.get();
    //print("ulogaresult $ulogaResult");
    uloge = ulogaResult?.result;
    //print("uloge $uloge");
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
          _selectedImageBytes = result.files.single.bytes; // Čuva sliku lokalno
        });
        fileName = result.files.single.name;
        //print("✅ Slika odabrana!");
      }
    } catch (e) {
      print("❌ Greška pri odabiru slike: $e");
    }
  }

  Widget _buildKategorijaDropdown() {
    return FormBuilderDropdown<int>(
      name: "kategorijaId",
      initialValue: _selectedKategorijaId,
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
      items: _kategorije.map((kategorija) {
        return DropdownMenuItem<int>(
          value: kategorija.id,
          child: Text(kategorija.naziv ?? ""),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedKategorijaId = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Odmicanje od ivica ekrana
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
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
                mainAxisSize: MainAxisSize.min, // Sprječava prekomjerno širenje
                children: [
                  // Red sa naslovom i X dugmetom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.zaposlenik?.korisnik?.korisnickoIme ??
                            "Zaposlenik detalji",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black54),
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
                                builder: (context) => ZaposlenikPage()),
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
                            //print("Validacija nije prošla!");
                            return;
                          }

                          var request = Map.from(_formKey.currentState!.value);
                          print("request $request");
                          if (request.containsKey('datumZaposlenja') &&
                              request['datumZaposlenja'] is DateTime) {
                            request['datumZaposlenja'] =
                                (request['datumZaposlenja'] as DateTime)
                                    .toIso8601String();
                          }
                          request['kategorijaId'] = _selectedKategorijaId;

                          try {
                            // Ako je korisnik odabrao novu sliku, prvo je uploaduj
                            if (_selectedImageBytes != null) {
                              String base64Image =
                                  base64Encode(_selectedImageBytes!);

                              /* var slikaRequest = {
                                "naziv": "naziv",
                                "slikaBase64": base64Image,
                                "tip": "tip",
                              };*/
                              var slikaRequest = {
                                "naziv": fileName,
                                "slikaBase64": base64Image,
                                "tip": fileName!
                                    .split('.')
                                    .last, // Ekstenzija kao tip (npr. jpg, png)
                              };

                              // print("⬆️ Upload slike...");
                              /* var novaSlika = await _zaposlenikSlikeProvider
                                  .insert(slikaRequest);*/

                              var novaSlika = await _slikaProfilaProvider
                                  .insert(slikaRequest);

                              //print("novaslika: $novaSlika");
                              //OVDJE   _<<<<<<<<<<<<<<<<<<<<<<        request['slikaId'] =
                              //  novaSlika.id; // Postavi slikaId u request
                              //print("✅ Slika spašena s ID: ${novaSlika.id}");
                              //request['korisnik']['slikaId'] = novaSlika.id;

                              var korisnikUpdateRequest = {
                                "ime": widget.zaposlenik!.korisnik!.ime,
                                "prezime": widget.zaposlenik!.korisnik!.prezime,
                                "email": widget.zaposlenik!.korisnik!.email,
                                "telefon": widget.zaposlenik!.korisnik!.telefon,
                                "status": widget.zaposlenik!.korisnik!.status,
                                "slikaId": novaSlika.id,
                              };

                              await _korisnikProvider.update(
                                  widget.zaposlenik!.korisnikId!,
                                  korisnikUpdateRequest);
                            }

                            /*if (widget.zaposlenik == null) {
                              await _zaposlenikProvider.insert(request);
                            } else {*/
                            print("request prije update: $request");
                            await _zaposlenikProvider.update(
                                widget.zaposlenik!.id!, request);
                            print(
                                "📦 Podaci koji se šalju poslije update: $request");
                            // }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Zaposlenik uspješno modifikovan.",
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
                            // print(widget.zaposlenik?.status);
                            // print("✅ Zaposlenik spašen!");

// Dodaj ulogu korisniku u tabelu korisnikuloga
// Dodaj ulogu korisniku u tabelu korisnikuloga (postavljanje request za korisnikuloga)
                            var korisnikUlogaRequest = {
                              'korisnikId': widget.zaposlenik!.korisnikId!,
                              'ulogaId': selectedUlogaId, // Odabrana uloga
                            };
                            print(("selectedulogaid $selectedUlogaId"));
                            print("korisnikulogarequesr $korisnikUlogaRequest");
                            /* await _korisnikUlogaProvider.insert(
                                widget.zaposlenik!.korisnikId!,
                                selectedUlogaId);*/
                            await _korisnikUlogaProvider
                                .insert(korisnikUlogaRequest);
                            //print("✅ Uloga povezana sa korisnikom!");

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ZaposlenikPage()),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Greška"),
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

      title: /*this.widget.zaposlenik?.struka ??*/ "Zaposlenik detalji",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          /* _buildInputField1("Ime", Icons.person, "ime"),
          SizedBox(height: 10),
          _buildInputField1("Prezime", Icons.person_2_outlined, "prezime"),*/
          /*  Row(
            children: [
              Expanded(
                child: _buildInputField1("Ime", Icons.person, "ime"),
              ),
              SizedBox(width: 10), // Razmak između dva polja
              Expanded(
                child: _buildInputField1(
                    "Prezime", Icons.person_2_outlined, "prezime"),
              ),
            ],
          ),*/
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // važno za poravnanje kad se prikaže greška
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildInputField1("Ime", Icons.person, "ime"),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    _buildInputField1(
                        "Prezime", Icons.person_2_outlined, "prezime"),
                  ],
                ),
              ),
            ],
          ),

          /* Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Pruža razmak između polja
            children: [
              Expanded(
                child: _buildInputField1("Ime", Icons.person, "ime"),
              ),
              SizedBox(width: 10), // Razmak između dva input polja
              Expanded(
                child: _buildInputField1(
                    "Prezime", Icons.person_2_outlined, "prezime"),
              ),
            ],
          ),*/

          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildDatePicker("DatumZaposlenja", "datumZaposlenja"),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    _buildDropdownField("Status", Icons.date_range, "status"),
                  ],
                ),
              ),
            ],
          ),

          // Polja sa ikonama
          //_buildDatePicker("DatumZaposlenja", "datumZaposlenja"),
          SizedBox(height: 10),
          _buildInputField1("Struka", Icons.description, "struka"),
          SizedBox(height: 10),
          //_buildDropdownField("Status", Icons.date_range,
          //    "status"), // Ovdje koristiš novi dropdown
          // SizedBox(height: 10),
          // _buildInputField("Status", Icons.title, "status"),
          //SizedBox(height: 10),
          _buildInputFieldNapomena("Napomena", Icons.notes, "napomena"),
          SizedBox(height: 10),
          _buildInputField1("Biografija", Icons.description, "biografija"),
          SizedBox(height: 10),
          /* _buildRoleDropdown(),
          SizedBox(height: 10),*/
          _buildKategorijaDropdown(),
          SizedBox(height: 10),
          _buildImagePicker(),
        ],
      ),
    );
  }

  /*Widget _buildRoleDropdown() {
    // Filtriraj uloge koje nisu 'admin'
    List<Uloga> filteredRoles = uloge
        .where((role) => role.naziv.toLowerCase() != 'administrator')
        .toList();
    // Provera da li postoji dodeljena uloga za zaposlenika

    //print("selectedUlogaId: $selectedUlogaId");

    print("selectedUlogaId: $selectedUlogaId");

    // print("filtered roles $filteredRoles");
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
  }*/
  /*
Widget _buildRoleDropdown2() {
  // Filtriraj uloge koje nisu 'administrator'
  List<Uloga> filteredRoles =
      uloge.where((role) => role.naziv.toLowerCase() != 'administrator').toList();
  print("filteredroles $filteredRoles");

  return FormBuilderDropdown<int>(  // Koristimo int tip umesto String
    name: "ulogaId",
    decoration: InputDecoration(
      labelText: "Uloga",
      prefixIcon: Icon(Icons.person),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null) {
        return 'Odaberite ulogu';
      }
      return null;
    },
    items: filteredRoles.map((role) {
      return DropdownMenuItem<int>(  // Koristimo int kao tip
        value: role.id,  // Ne pretvaramo u string, koristimo int
        child: Text(role.naziv!),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        // Pohranjujemo selektovanu ulogu kao int
        selectedUlogaId = value;
      });
    },
  );
}
*/
/*
Widget _buildRoleDropdown1() {
  // Filtriraj uloge koje nisu 'admin'
  List<Uloga> filteredRoles =
      uloge.where((role) => role.naziv.toLowerCase() != 'administrator').toList();

  return FormBuilderDropdown<int>(
    name: "ulogaId",
    decoration: InputDecoration(
      labelText: "Uloga",
      prefixIcon: Icon(Icons.person),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null) {
        return 'Odaberite ulogu';
      }
      return null;
    },
    items: filteredRoles.map((role) {
      return DropdownMenuItem<int>(  // Koristi int kao tip
        value: role.id,  // ID je int
        child: Text(role.naziv!),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        // Ovdje pohranjuješ selektovanu ulogu kao int
        selectedUlogaId = value as String?;
      });
    },
  );
}
*/

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

        // Validacija za "Struka"
        if (name == "struka") {
          if (value != null && value.isNotEmpty) {
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
          }
        }
        // Validacija za "Biografija"
        else if (name == "biografija") {
          if (value != null && value.isNotEmpty) {
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Biografija mora početi velikim slovom';
            }
            if (value.length < 3) {
              return 'Biografija mora imati najmanje 3 karaktera';
            }
          }
        }
        // Validacija za "Ime"
        else if (name == "ime") {
          if (value != null && value.isNotEmpty) {
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Ime mora početi velikim slovom';
            }
            if (value.length < 3) {
              return 'Ime mora imati najmanje 3 karaktera';
            }
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž]+$').hasMatch(value)) {
              return 'Ime može sadržavati samo slova';
            }
          }
        }
        // Validacija za "Prezime"
        else if (name == "prezime") {
          if (value != null && value.isNotEmpty) {
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Prezime mora početi velikim slovom';
            }
            if (value.length < 3) {
              return 'Prezime mora imati najmanje 3 karaktera';
            }
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž]+$').hasMatch(value)) {
              return 'Prezime može sadržavati samo slova';
            }
          }
        }

        return null; // Ako sve prođe, nema greške
      },
    );
  }

  /*Widget _buildInputField1(String label, IconData icon, String name,
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
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž]+$').hasMatch(value)) {
              return 'Struka može sadržavati samo slova';
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
        } else if (name == "Ime") {
          // Ako nije prazno, provjeri validaciju
          if (value != null && value.isNotEmpty) {
            // Provera da li počinje velikim slovom
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Ime mora početi velikim slovom';
            }
            // Provera minimalne dužine
            if (value.length < 3) {
              return 'Ime mora imati najmanje 3 karaktera';
            }
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž]+$').hasMatch(value)) {
              return 'Ime može sadržavati samo slova';
            }
          }
        } else if (name == "prezime") {
          // Ako nije prazno, provjeri validaciju
          if (value != null && value.isNotEmpty) {
            // Provera da li počinje velikim slovom
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Prezime mora početi velikim slovom';
            }
            // Provera minimalne dužine
            if (value.length < 3) {
              return 'Prezime mora imati najmanje 3 karaktera';
            }
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž]+$').hasMatch(value)) {
              return 'Ime može sadržavati samo slova';
            }
          }
        }

if (name == "Ime") {
          // Ako nije prazno, provjeri validaciju
          if (value != null && value.isNotEmpty) {
            // Provera da li počinje velikim slovom
            if (!RegExp(r'^[A-ZČĆĐŠŽ]').hasMatch(value)) {
              return 'Ime mora početi velikim slovom';
            }
            // Provera minimalne dužine
            if (value.length < 3) {
              return 'Ime mora imati najmanje 3 karaktera';
            }
            if (!RegExp(r'^[A-ZČĆĐŠŽa-zčćđšž]+$').hasMatch(value)) {
              return 'Ime može sadržavati samo slova';
            }
          }
        }



        return null;
      },
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
          child: _selectedImageBytes != null
              ? Image.memory(
                  _selectedImageBytes!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : widget.zaposlenik?.korisnik?.slika != null
                  ? Image.memory(
                      base64Decode(widget.zaposlenik!.korisnik!.slika!.slika!),
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

  Widget _buildDropdownField(String label, IconData icon, String name) {
    return FormBuilderDropdown(
      name: name,
      initialValue: _initialValue[name],
      //initialValue: 'Aktivan',
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.check_circle),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Odaberite status';
        }
        return null;
      },
      items: ['Aktivan', 'Neaktivan']
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _initialValue[name] = value; // Ažurira odabranu vrijednost
        });
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
    );
  }
}
