import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/screens/kategorije.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class KategorijaDetaljiPage extends StatefulWidget {
  Kategorija? kategorija;
  KategorijaDetaljiPage({Key? key, this.kategorija}) : super(key: key);

  @override
  State<KategorijaDetaljiPage> createState() => _KategorijaDetaljiPageState();
}

class _KategorijaDetaljiPageState extends State<KategorijaDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  //late KategorijaProvider _kategorijaProvider;
  late KategorijaProvider _kategorijaProvider;

  SearchResult<Kategorija>? kategorijaResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.kategorija?.naziv,
      /* 'sadrzaj': widget.novost?.sadrzaj,
      'datum': widget.novost?.datum,*/
    };

    //_kategorijaProvider = context.read<KategorijaProvider>();
    _kategorijaProvider = context.read<KategorijaProvider>();

    initForm();
  }

  Future initForm() async {
    kategorijaResult = await _kategorijaProvider.get();
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
          padding: const EdgeInsets.all(210.0), // Odmicanje od ivica ekrana
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // X dugme u gornjem desnom uglu
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Color.fromARGB(137, 132, 131, 131)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 10),

                isLoading ? CircularProgressIndicator() : _buildForm(),
                SizedBox(height: 20), // Prostor između forme i dugmadi

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: Text("Nazad"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.saveAndValidate();
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          print("Validacija nije prošla!");
                          return;
                        }

                        var request = Map.from(_formKey.currentState!.value);
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
                          Navigator.pop(context, false);
                          return;
                        }

                        try {
                          if (widget.kategorija == null) {
                            await _kategorijaProvider.insert(request);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Kategorija uspješno dodana.",
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
                            await _kategorijaProvider.update(
                                widget.kategorija!.id!, request);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Kategorija uspješno modifikovana.",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KategorijaPage(),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      title: widget.kategorija?.naziv ?? "Kategorija detalji",
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
          _buildInputField("Naziv", Icons.title, "naziv"),
          SizedBox(height: 10),
         
        ],
      ),
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
        // Proveri da li sadrži samo slova i razmake
        final regexOnlyLetters = RegExp(r'^[a-zA-Z\s]+$');
        if (!regexOnlyLetters.hasMatch(value)) {
          return 'Dozvoljena su samo slova';
        }
        // Proveri da li je minimum 3 karaktera
        if (value.trim().length < 3) {
          return 'Naziv mora imati minimum 3 slova';
        }
        // Proveri da li je prvo slovo veliko
        if (!RegExp(r'^[A-Z]').hasMatch(value.trim())) {
          return 'Prvo slovo mora biti veliko';
        }
        return null;
      },
    );
  }

 
}
