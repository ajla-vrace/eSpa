import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/termin.dart';
import 'package:espa_admin/providers/termin_provider.dart';
import 'package:espa_admin/screens/termini.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TerminDetaljiPage extends StatefulWidget {
  Termin? termin;
  TerminDetaljiPage({Key? key, this.termin}) : super(key: key);

  @override
  State<TerminDetaljiPage> createState() => _TerminDetaljiPageState();
}

class _TerminDetaljiPageState extends State<TerminDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late TerminProvider _terminProvider;

  SearchResult<Termin>? terminResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Proveri da li je widget.termin null
    if (widget.termin != null) {
      String? pocetakString = widget.termin?.pocetak; // Pocetak kao String
      String? krajString = widget.termin?.kraj; // Kraj kao String

      // Skraćivanje na format HH:mm
      String formattedPocetak =
          pocetakString != null ? pocetakString.substring(0, 5) : '';
      String formattedKraj =
          krajString != null ? krajString.substring(0, 5) : '';

      _initialValue = {
        'pocetak': formattedPocetak, // Dodeljujemo formatirani string
        'kraj': formattedKraj, // Dodeljujemo formatirani string
      };
    } else {
      // Ako nema `widget.termin`, onda je forma prazna za insert
      _initialValue = {
        'pocetak': '',
        'kraj': '',
      };
    }

    _terminProvider = context.read<TerminProvider>();

    initForm();
  }

  Future initForm() async {
    terminResult = await _terminProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> isDuplicateTermin(DateTime pocetak, DateTime kraj) async {
    var existingTermini = terminResult?.result ?? [];
    for (var termin in existingTermini) {
      DateTime existingPocetak = _parseTime(termin.pocetak!);
      DateTime existingKraj = _parseTime(termin.kraj!);

      if ((pocetak.isBefore(existingKraj) && kraj.isAfter(existingPocetak)) ||
          (pocetak.isAtSameMomentAs(existingPocetak) ||
              kraj.isAtSameMomentAs(existingKraj))) {
        return true; // Termin se preklapa
      }
    }
    return false; // Termin ne postoji
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: /*widget.termin?.pocetak ??*/ "Termin detalji",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(210.0),
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
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                        icon: Icon(Icons.close, color: Colors.black54),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                ),
                isLoading ? CircularProgressIndicator() : _buildForm(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Dugme za nazad
                      },
                      // ignore: sort_child_properties_last
                      child: Text("Nazad"),
                      style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
                          print("Validacija nije prošla!");
                          return;
                        }

                        var request = Map.from(_formKey.currentState!.value);
                        var currentValues = Map.from(_formKey.currentState!.value);

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
                          String pocetakStr = request['pocetak'];
                          String krajStr = request['kraj'];

                          DateTime pocetak = _parseTime(pocetakStr);
                          DateTime kraj = _parseTime(krajStr);

                          if (await isDuplicateTermin(pocetak, kraj)) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Greška"),
                                content: Text("Termin se preklapa sa postojećim terminima."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (widget.termin == null) {
                            await _terminProvider.insert(request);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Termin uspješno dodan.",
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
                            await _terminProvider.update(widget.termin!.id!, request);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Termin uspješno modifikovan.",
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
                              builder: (context) => TerminPage(),
                            ),
                          );
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Greška"),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          _buildInputField1("Pocetak termina", Icons.access_time, "pocetak"),
          SizedBox(height: 10),
          _buildInputField1("Kraj termina", Icons.watch_later, "kraj"),
        ],
      ),
    );
  }

  Widget _buildInputField1(String label, IconData icon, String name) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ovo polje je obavezno.";
        }

        RegExp timeFormat = RegExp(r'^\d{2}:\d{2}$');
        if (!timeFormat.hasMatch(value)) {
          return "Format mora biti HH:mm (npr. 09:00).";
        }

        if (_formKey.currentState != null) {
          final fields = _formKey.currentState!.value;
          String? pocetak = fields['pocetak'];
          String? kraj = fields['kraj'];

          try {
            DateTime pocetakTime = _parseTime(pocetak!);
            DateTime krajTime = _parseTime(kraj!);

            if (name == "pocetak") {
              if (pocetakTime.isBefore(DateTime(0, 1, 1, 10, 0)) || pocetakTime.isAfter(DateTime(0, 1, 1, 20, 0))) {
                return "Početak termina mora biti između 10:00 i 20:00.";
              }

              if (kraj.isNotEmpty) {
                if (pocetakTime.isAfter(krajTime)) {
                  return "Početak termina mora biti pre kraja.";
                }
                if (krajTime.difference(pocetakTime) != Duration(hours: 1)) {
                  return "Termin mora trajati tačno 1h.";
                }
              }
            }

            if (name == "kraj") {
              if (krajTime.isBefore(DateTime(0, 1, 1, 11, 0)) || krajTime.isAfter(DateTime(0, 1, 1, 21, 0))) {
                return "Kraj termina mora biti između 11:00 i 21:00.";
              }

              if (pocetak.isNotEmpty) {
                if (krajTime.isBefore(pocetakTime)) {
                  return "Kraj termina mora biti posle početka.";
                }
                if (krajTime.difference(pocetakTime) != Duration(hours: 1)) {
                  return "Termin mora trajati tačno 1h.";
                }
              }
            }
          } catch (e) {
            return "Neispravan format vremena.";
          }
        }
        return null;
      },
    );
  }

  DateTime _parseTime(String time) {
    List<String> parts = time.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return DateTime(0, 1, 1, hours, minutes);
  }
}
