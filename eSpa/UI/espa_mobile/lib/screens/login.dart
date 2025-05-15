import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/novost_provider.dart';
import 'package:espa_mobile/screens/home.dart';
import 'package:espa_mobile/screens/registracija.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late NovostProvider _novostProvider;
  late KorisnikProvider _korisnikProvider;

  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _novostProvider = context.read<NovostProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: width * 0.9),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    /* Image.network(
                      "https://www.fit.ba/content/public/images/og-image.jpg",
                      height: 100,
                      width: 100,
                    ),*/
                    const Icon(
                      Icons.spa, // Koristite odgovarajuću ikonu za spa
                      size: 100, // Velicina ikone
                      color: Color.fromARGB(255, 36, 62, 37), // Boja ikone
                    ),
                    //Text("eSpa"),
                    Text(
                      "eSpa",
                      style: TextStyle(
                        fontFamily: 'cursive',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              child: const Text("Login"),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Nemaš profil?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistracijaScreen()),
                            );
                          },
                          child: Text(
                            "Registruj se",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

/*
  Future<void> _login() async {
    var username = _usernameController.text;
    var password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog("Username and password are required!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Authorization.username = username;
      Authorization.password = password;
      await setUserName(username);
      print("Pozivam novostProvider.get()");
      await _novostProvider.get();
      print("Uspješno dobio novosti");
      // await _novostProvider.get();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }*/
  Future<void> _login() async {
    var username = _usernameController.text;
    var password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog("Username and password are required!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Authorization.username = username;
      Authorization.password = password;
      await setUserName(username);

      // POZIV ZA DOBIJANJE KORISNIKA
      var korisnici =
          await _korisnikProvider.get(filter: {'KorisnickoIme': username});

      if (korisnici.result.isEmpty) {
        _showErrorDialog("Korisnik nije pronađen. Nedozvoljen pristup.");
        return;
      }

      var korisnik = korisnici.result[0];

      // Provjera uloge za mobilnu verziju - ako korisnik IMA ulogu, odbij login
      if (korisnik.korisnikUlogas.isNotEmpty) {
        _showErrorDialog(
            "Korisnik sa ulogom nema pristup mobilnoj aplikaciji.");
        return;
      }

      // Ako korisnik nema ulogu - dozvoli login
      LoggedUser.id = korisnik.id;
      LoggedUser.ime = korisnik.ime;
      LoggedUser.prezime = korisnik.prezime;
      LoggedUser.korisnickoIme = korisnik.korisnickoIme;
      LoggedUser.isAdmin = false;
      LoggedUser.isZaposlenik = false;
      LoggedUser.isBlokiran = korisnik.isBlokiran ?? false;
      LoggedUser.uloga = "";

      print("Pozivam novostProvider.get()");
      await _novostProvider.get();
      print("Uspješno dobio novosti");

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      _showErrorDialog("Nedozvoljen pristup.");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
