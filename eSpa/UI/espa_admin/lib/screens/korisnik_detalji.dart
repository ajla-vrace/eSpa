import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/screens/korisnici.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class KorisnikDetaljiPage extends StatefulWidget {
  Korisnik? korisnik;
  KorisnikDetaljiPage({Key? key, this.korisnik}) : super(key: key);

  @override
  State<KorisnikDetaljiPage> createState() => _KorisnikDetaljiPageState();
}

class _KorisnikDetaljiPageState extends State<KorisnikDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  //late KategorijaProvider _kategorijaProvider;
  late KorisnikProvider _korisnikProvider;

  SearchResult<Korisnik>? korisnikResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.korisnik?.ime,
       'prezime': widget.korisnik?.prezime,
        'email': widget.korisnik?.email,
         'telefon': widget.korisnik?.telefon,
         'korisnickoIme': widget.korisnik?.korisnickoIme,
         
           'status': widget.korisnik?.status,
     /* 'sadrzaj': widget.novost?.sadrzaj,
      'datum': widget.novost?.datum,*/
    };

    //_kategorijaProvider = context.read<KategorijaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();

    initForm();
  }

  Future initForm() async {
    korisnikResult = await _korisnikProvider.get();
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
        padding: const EdgeInsets.all(30.0), // Odmicanje od ivica ekrana
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
                      if (widget.korisnik == null) {
                        await _korisnikProvider.insert(request);
                      } else {
                        await _korisnikProvider.update(widget.korisnik!.id!, request);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KorisnikPage(),
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
    title: this.widget.korisnik?.korisnickoIme ?? "Korisnik details",
  );
}



  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          // Polja sa ikonama
          _buildInputField("Ime", Icons.person, "ime"),
           SizedBox(height: 10),
           _buildInputField("Prezime", Icons.person_2_outlined, "prezime"),
            SizedBox(height: 10),
            _buildInputField("Email", Icons.email, "email"),
             SizedBox(height: 10),
              _buildInputField("Telefon", Icons.phone, "telefon"),
               SizedBox(height: 10),
             _buildInputField("Korisnicko ime", Icons.account_box, "korisnickoIme"),
             // SizedBox(height: 10),
            _buildSwitchField("Status", "status"),

               //_buildInputField("Status", Icons.title, "status"),
               _buildInputField("Password", Icons.lock, "password"),
                SizedBox(height: 10),
               _buildInputField("Password potvrda", Icons.lock_outline, "passwordPotvrda"),

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
/*Widget _buildSwitchField(String label, String name) {
  return FormBuilderSwitch(
    name: name,
    title: Text(label),
    initialValue: _initialValue[name] as bool? ?? false, // Postavi podrazumevano na false ako je null
  );
}*/

/*Widget _buildSwitchField(String label, String name) {
  return FormBuilderSwitch(
    name: name,
    title: Text(label),
    initialValue: (_initialValue[name] != null) ? (_initialValue[name] as bool) : false, // Sigurna provera
    decoration: InputDecoration(border: InputBorder.none), // Sprečava vizuelne probleme
  );
}*/
Widget _buildSwitchField(String label, String name) {
  return FormBuilderSwitch(
    name: name,
    title: Text(label),
    initialValue: (_initialValue[name] != null) ? (_initialValue[name] as bool) : false, // Sigurna provera
    decoration: InputDecoration(
      border: InputBorder.none,
      prefixIcon: Icon(Icons.check_circle_outline), // Dodavanje ikone
    ), // Sprečava vizuelne probleme
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

