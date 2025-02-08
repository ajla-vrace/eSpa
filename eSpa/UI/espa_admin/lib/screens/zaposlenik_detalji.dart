import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/zaposlenik.dart';
import 'package:espa_admin/providers/zaposlenik_provider.dart';
import 'package:espa_admin/screens/zaposlenici.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ZaposlenikDetaljiPage extends StatefulWidget {
  Zaposlenik? zaposlenik;
  ZaposlenikDetaljiPage({Key? key, this.zaposlenik}) : super(key: key);

  @override
  State<ZaposlenikDetaljiPage> createState() => _ZaposlenikDetaljiPageState();
}

class _ZaposlenikDetaljiPageState extends State<ZaposlenikDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  //late KategorijaProvider _kategorijaProvider;
  late ZaposlenikProvider _zaposlenikProvider;

  SearchResult<Zaposlenik>? zaposlenikResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'korisnikId': widget.zaposlenik?.korisnikId.toString(),
      'datumZaposlenja': widget.zaposlenik?.datumZaposlenja,
      'struka': widget.zaposlenik?.struka,
      'status': widget.zaposlenik?.status,
      'napomena': widget.zaposlenik?.napomena,
    };

    //_kategorijaProvider = context.read<KategorijaProvider>();
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
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0), // Odmicanje od ivica ekrana
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
                isLoading ? CircularProgressIndicator() : _buildForm(),
                SizedBox(
                    height: 20), // Dodavanje prostora između forme i dugmeta
                Center(
                  // Koristimo Center za centriranje dugmeta
                  child: ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.saveAndValidate();
                      var request = new Map.from(_formKey.currentState!.value);
                      if (request['datumZaposlenja'] != null) {
                        request['datumZaposlenja'] =
                            request['datumZaposlenja'].toIso8601String();
                      }
                      try {
                        if (widget.zaposlenik == null) {
                          await _zaposlenikProvider.insert(request);
                        } else {
                          print("Request data: ${request}");

                          await _zaposlenikProvider.update(
                              widget.zaposlenik!.id!, request);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZaposlenikPage(),
                          ),
                        );
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
          ),
        ),
      ),
      title: this.widget.zaposlenik?.struka ?? "Zaposlenik details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          // Polja sa ikonama
          _buildInputField("Korisnik id", Icons.title, "korisnikId"),
          SizedBox(height: 10),
          //_buildInputField("Datum zaposlenja", Icons.title, "datumZaposlenja"),
          _buildDatePickerField(
              "Datum zaposlenja", Icons.calendar_today, "datumZaposlenja"),

          SizedBox(height: 10),
          _buildInputField("Struka", Icons.description, "struka"),
          SizedBox(height: 10),
          _buildInputField("Status", Icons.check_circle, "status"),
          SizedBox(height: 10),
          _buildInputField("Napomena", Icons.note, "napomena"),
          SizedBox(height: 10),

          //_buildInputField("Datum", Icons.attach_money, "datum"),
          //SizedBox(height: 10),
          //_buildInputField("Trajanje (min)", Icons.access_time, "trajanje"), // Dodano trajanje
          // SizedBox(height: 10),
          /*_buildDropdownField(
            "Kategorija",
            Icons.list,
            "kategorijaId",
            kategorijaResult?.result ?? [],
          ),
         */
        ],
      ),
    );
  }

  // Funkcija za kreiranje input polja sa ikonom
  Widget _buildInputField(String label, IconData icon, String name) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
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
  /*Widget _buildDatePickerField(String label, IconData icon, String name) {
  return FormBuilderField<DateTime>(
    name: name,
    builder: (field) {
      return InkWell(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: field.value ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (selectedDate != null) {
            field.didChange(selectedDate);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(),
          ),
          child: Text(
            field.value != null
                ? field.value!.toLocal().toString().split(' ')[0] // Formatiraj datum
                : 'Izaberite datum',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    },
  );
}*/
  Widget _buildDatePickerField(String label, IconData icon, String name) {
    return FormBuilderField<DateTime>(
      // Koristimo DateTime umesto String
      name: name,
      builder: (field) {
        return InkWell(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: field.value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              field.didChange(selectedDate);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(),
            ),
            child: Text(
              field.value != null
                  ? field.value!
                      .toLocal()
                      .toString()
                      .split(' ')[0] // Prikazivanje datuma u formatu YYYY-MM-DD
                  : 'Izaberite datum',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
