//import 'package:espa_admin/screens/home.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/screens/home.dart';
import 'package:espa_admin/screens/rezervacije.dart';
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
                const Icon(
                  Icons.spa,
                  size: 100,
                  color: Color.fromARGB(255, 21, 109, 51), // Boja ikone
                ),
                Text(
                  "eSpa",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                    color: Color.fromARGB(255, 36, 62, 37),
                  ),
                ),
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
                  obscureText: true,
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 8,
                ),
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
                            content: Text(
                                "Korisnik nije pronađen. Nedozvoljen pristup."),
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
                            content: Text(
                                "Samo admin i zaposlenici mogu pristupiti."),
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
                      LoggedUser.korisnickoIme = korisnik.korisnickoIme;
                      LoggedUser.isAdmin = korisnik.isAdmin;
                      LoggedUser.isZaposlenik = korisnik.isZaposlenik;
                      LoggedUser.isBlokiran = korisnik.isBlokiran;
                      LoggedUser.uloga =
                          korisnik.korisnikUlogas[0].uloga!.naziv;

                      await _uslugaProvider.get();

                      if (LoggedUser.isAdmin!) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else if (LoggedUser.isZaposlenik!) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => RezervacijePage()),
                        );
                      }

                      /* Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );*/
                      // ignore: unused_catch_clause
                    } on Exception catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Greška"),
                          content: /*Text(e.toString()),*/
                              Text("Nedozvoljen pristup."),
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
  }
}
