import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/models/usluga.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/screens/usluge.dart';
import 'package:espa_admin/widgets/master_screen.dart';
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

  SearchResult<Kategorija>? kategorijaResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.usluga?.naziv,
      'opis': widget.usluga?.opis,
      'cijena': widget.usluga?.cijena?.toString(),
      'trajanje': widget.usluga?.trajanje?.toString(),
      'kategorijaId': widget.usluga?.kategorijaId?.toString()
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
                        if (widget.usluga == null) {
                          await _uslugaProvider.insert(request);
                        } else {
                          await _uslugaProvider.update(
                              widget.usluga!.id!, request);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UslugaPage(),
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
      title: this.widget.usluga?.naziv ?? "Usluga details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
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
