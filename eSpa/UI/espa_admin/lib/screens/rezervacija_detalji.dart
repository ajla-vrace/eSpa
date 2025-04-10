import 'package:espa_admin/models/rezervacija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/rezervacija_provider.dart';
import 'package:espa_admin/screens/rezervacije.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RezervacijaDetaljiPage extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijaDetaljiPage({Key? key, this.rezervacija}) : super(key: key);

  @override
  State<RezervacijaDetaljiPage> createState() => _RezervacijaDetaljiPageState();
}

class _RezervacijaDetaljiPageState extends State<RezervacijaDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late RezervacijaProvider _rezervacijaProvider;

  SearchResult<Rezervacija>? rezervacijaResult;
  bool isLoading = true;

late DateTime datumRezervacije; // Datum rezervacije
  late String terminPocetak;
  
  String? selectedStatus; // Početak termina


 // Funkcija za provjeru da li je termin prošao
  bool isTerminProsao(DateTime datum, String pocetak) {
    Duration pocetakDuration = timeStringToDuration(pocetak);
    DateTime terminDatum = datum.add(pocetakDuration);
    return terminDatum.isBefore(DateTime.now()); // Ako je termin prošao
  }

  // Pretvori String u Duration
  Duration timeStringToDuration(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }


 List<String> statusi = ['Aktivna', 'Otkazana','Zavrsena'];

  @override
  void initState() {
    super.initState();
    _initialValue = {
      //'naslov': widget.novost?.naslov,
     // 'sadrzaj': widget.novost?.sadrzaj,
     // 'datumKreiranja': widget.novost?.datumKreiranja,
       //'korisnickoIme': widget.rezervacija?.korisnik.korisnickoIme,
      'status': widget.rezervacija?.status,
    };

    _rezervacijaProvider = context.read<RezervacijaProvider>();

datumRezervacije = widget.rezervacija!.datum!; // Datum iz rezervacije
    terminPocetak = widget.rezervacija!.termin!.pocetak!; // Vreme početka termina
    selectedStatus = widget.rezervacija?.status; // Trenutni status rezervacije

    initForm();
    print("status $_initialValue");
   

    // Ako je termin prošao, ukloni "Otkazana" iz liste
    if (isTerminProsao(datumRezervacije, terminPocetak)) {
      print("otkazana remove");
      statusi.remove('Otkazana');
    }
    else{
       print("zavrsena remove");
      statusi.remove('Zavrsena');
    }
  }

  Future initForm() async {
    rezervacijaResult = await _rezervacijaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Početna lista statusa koja sadrži "Aktivna" i "Otkazana"
    
    return MasterScreenWidget(
      // Ostatak sadržaja dolazi iz MasterScreenWidget-a
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(160.0), // Odmicanje od ivica ekrana
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
            /* child: Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : _buildForm(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
                          print("Validacija nije prošla!");
                          return;
                        }
                        var request = Map.from(_formKey.currentState!.value);

                        var currentValues =
                            Map.from(_formKey.currentState!.value);

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
                          } else {
                            await _novostProvider.update(
                                widget.novost!.id!, request);
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NovostPage(),
                            ),
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
                  ),
                ],
              ),*/
/*
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Sprečava prekomerno širenje
                children: [
                  isLoading ? const CircularProgressIndicator() : _buildForm(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          print("Validacija nije prošla!");
                          return;
                        }
                        var request = Map.from(_formKey.currentState!.value);
                        var currentValues =
                            Map.from(_formKey.currentState!.value);

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
                          } else {
                            await _novostProvider.update(
                                widget.novost!.id!, request);
                          }
                          Navigator.push(
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
                  ),
                ],
              ),
            ),*/

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Sprečava prekomerno širenje
                children: [
                  // Red sa naslovom i X dugmetom
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
                                builder: (context) => RezervacijePage()),
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

                         // bool isChanged = false;
                          print("Initial Values: $_initialValue");
                          print("Current Values: $currentValues");
                         /* _initialValue.forEach((key, value) {
                            if (currentValues[key] != value) {
                              isChanged = true;
                            }
                          });

                          if (!isChanged) {
                            Navigator.pop(context, false);
                            return;
                          }*/
                          print("widget rezervacija ${widget.rezervacija}");
                          try {
                            print(" u try smo za insert");
                            if (widget.rezervacija == null) {
                              await _rezervacijaProvider.insert(request);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Rezervacija uspješno dodana.",
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
                              print(" u else smo za update");
                              await _rezervacijaProvider.update(
                                  widget.rezervacija!.id!, request);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Rezervacija uspješno modifikovana.",
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

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RezervacijePage()),
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

      title: /*this.widget.novost?.naslov ??*/ "Rezervacija detalji",
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
          // _buildInputField("Naslov", Icons.title, "naslov"),
          //SizedBox(height: 10),
          // _buildInputField1("Sadrzaj", Icons.description, "sadrzaj"),
          //SizedBox(height: 10),
          _buildStatusDropdownField(
              "Status", "status"), // Ovdje koristiš novi dropdown
          SizedBox(height: 10),
        ],
      ),
    );
  }

/*
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
*/
  Widget _buildStatusDropdownField(String label, String name) {
    // Proveri da li je novost null, što znači da se kreira nova novost
    if (widget.rezervacija == null) {
      // Ako je nova novost, ne prikazuj status
      return SizedBox.shrink(); // Vraća prazni widget (ne prikazuje ništa)
    }

    // Ako nije nova novost, prikaži status dropdown
    return FormBuilderDropdown<String>(
      name: name,
      initialValue: _initialValue[name] ??
          "Aktivna", // Podrazumevana vrednost za ažuriranje
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(Icons.check_circle_outline), // Ikona pored dropdown menija
        border: OutlineInputBorder(),
      ),
      items: statusi.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
      onChanged: (value) {
        setState(() {
          _initialValue[name] =
              value; // Ažuriraj status kada se odabere nova vrednost
        });
      },
    );
  }
/*
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
  }*/
}
