//import 'package:espa_admin/screens/home.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/screens/home.dart';
import 'package:espa_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late UslugaProvider _uslugaProvider;
  late KorisnikProvider _korisnikProvider;
  @override
  Widget build(BuildContext context) {
    _uslugaProvider = context.read<UslugaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Image.network(
                  "https://www.fit.ba/content/public/images/og-image.jpg",
                  //"https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?cs=srgb&dl=pexels-souvenirpixels-417074.jpg&fm=jpg",
                  height: 100,
                  width: 100,
                ),
                /*Image.asset(
                  "assets/images/logo.jpg",
                  height: 100,
                  width: 100,
                ),*/
                TextField(
                  decoration: InputDecoration(
                      labelText: "Username", prefixIcon: Icon(Icons.email)),
                  controller: _usernameController,
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Password", prefixIcon: Icon(Icons.password)),
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 8,
                ),
                /* ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      // _passwordController.text = username;

                      //print("login proceed na login stranici $username $password");

                      Authorization.username = username;
                      Authorization.password = password;

                      await setUserName(username);
                      try {
                        await _korisnikProvider
                            .get(filter: {'KorisnickoIme': password});
                        await _uslugaProvider.get();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => /*const*/ HomePage(),
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
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Login"))*/

                ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    Authorization.username = username;
                    Authorization.password = password;

                    await setUserName(username);

                    try {
                      var korisnici = await _korisnikProvider
                          .get(filter: {'KorisnickoIme': username});

                      if (korisnici.result.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text("Korisnik nije pronađen. Nedozvoljen pristup."),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"))
                            ],
                          ),
                        );
                        return;
                      }

                      var korisnik = korisnici.result[0];

                      // Ovo pretpostavlja da korisnik ima `uloge` kao listu
                      if (korisnik.korisnikUlogas.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Nedozvoljen pristup"),
                            content: Text("Samo admin i zaposlenici mogu pristupiti."),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"))
                            ],
                          ),
                        );
                        return;
                      }

                      // Ako ima ulogu, nastavi dalje
                      // Npr. zapamti podatke:
                      LoggedUser.id = korisnik.id;
                      LoggedUser.ime = korisnik.ime;
                      LoggedUser.prezime = korisnik.prezime;
                      LoggedUser.korisnickoIme=korisnik.korisnickoIme;
                      LoggedUser.isBlokiran=korisnik.isBlokiran;
                      LoggedUser.uloga = korisnik.korisnikUlogas[0].uloga!.naziv;

                      await _uslugaProvider.get();

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    // ignore: unused_catch_clause
                    } on Exception catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Greška"),
                          content: /*Text(e.toString()),*/Text("Nedozvoljen pristup."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"))
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
    }  }

