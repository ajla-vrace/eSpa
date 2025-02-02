import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/models/search_result.dart';
//import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
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
  //late KategorijaProvider _kategorijaProvider;
  late NovostProvider _novostProvider;

  SearchResult<Novost>? novostResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naslov': widget.novost?.naslov,
      'sadrzaj': widget.novost?.sadrzaj,
      'datum': widget.novost?.datum,
    };

    //_kategorijaProvider = context.read<KategorijaProvider>();
    _novostProvider = context.read<NovostProvider>();

    initForm();
  }

  Future initForm() async {
    novostResult = await _novostProvider.get();
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

                    try {
                      if (widget.novost == null) {
                        await _novostProvider.insert(request);
                      } else {
                        await _novostProvider.update(widget.novost!.id!, request);
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
        ),
      ),
    ),
    title: this.widget.novost?.naslov ?? "Novost details",
  );
}



  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          // Polja sa ikonama
          _buildInputField("Naslov", Icons.title, "naslov"),
          SizedBox(height: 10),
          _buildInputField("Sadrzaj", Icons.description, "sadrzaj"),
         
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
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item.id.toString(),
                child: Text(item.naziv ?? ""),
              ))
          .toList(),
    );
  }
}

