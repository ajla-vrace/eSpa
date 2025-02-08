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
  //late KategorijaProvider _kategorijaProvider;
  late TerminProvider _terminProvider;

  SearchResult<Termin>? terminResult;
  bool isLoading = true;









  @override
  void initState() {
    super.initState();


 // Proveri da li je widget.termin null
  if (widget.termin != null) {
    String? pocetakString = widget.termin?.pocetak;  // Pocetak kao String
    String? krajString = widget.termin?.kraj;        // Kraj kao String

    // Skraćivanje na format HH:mm
    String formattedPocetak = pocetakString != null ? pocetakString.substring(0, 5) : '';
    String formattedKraj = krajString != null ? krajString.substring(0, 5) : '';

    _initialValue = {
      'pocetak': formattedPocetak, // Dodeljujemo formatirani string
      'kraj': formattedKraj,       // Dodeljujemo formatirani string
    };
  }





   /* _initialValue = {
      'pocetak': widget.termin?.pocetak,
       'kraj': widget.termin?.kraj,
    };
*/
    //_kategorijaProvider = context.read<KategorijaProvider>();
    _terminProvider = context.read<TerminProvider>();

    initForm();
  }

  Future initForm() async {
    terminResult = await _terminProvider.get();
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
              SizedBox(height: 20),  // Dodavanje prostora između forme i dugmeta
              Center(  // Koristimo Center za centriranje dugmeta
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.saveAndValidate();
                    var request = new Map.from(_formKey.currentState!.value);

                      var currentValues =
                          Map.from(_formKey.currentState!.value);

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
                      if (widget.termin == null) {
                        await _terminProvider.insert(request);
                      } else {
                        await _terminProvider.update(widget.termin!.id!, request);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TerminPage(),
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
    title: this.widget.termin?.pocetak ?? "Termin details",
  );
}



  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          // Polja sa ikonama
          _buildInputField("Pocetak termina", Icons.access_time, "pocetak"),
           SizedBox(height: 10),
          _buildInputField("Kraj termina", Icons.watch_later, "kraj"),
          SizedBox(height: 10),
          //_buildInputField("Sadrzaj", Icons.description, "sadrzaj"),
         
          // SizedBox(height: 10),
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
 /* Widget _buildDropdownField(
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
}

