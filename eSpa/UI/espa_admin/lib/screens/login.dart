//import 'package:espa_admin/screens/home.dart';
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
  @override
  Widget build(BuildContext context) {
    _uslugaProvider = context.read<UslugaProvider>();

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
                ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      _passwordController.text = username;

                      //print("login proceed na login stranici $username $password");

                      Authorization.username = username;
                      Authorization.password = password;

                      try {
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
                    child: Text("Login"))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
