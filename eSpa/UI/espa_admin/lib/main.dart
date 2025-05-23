import 'package:espa_admin/providers/kategorija_provider.dart';
import 'package:espa_admin/providers/komentar_provider.dart';
import 'package:espa_admin/providers/korisnikUloga_provider.dart';
import 'package:espa_admin/providers/korisnik_provider.dart';
import 'package:espa_admin/providers/novostKomentar_provider.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/providers/ocjena_provider.dart';
import 'package:espa_admin/providers/rezervacija_provider.dart';
import 'package:espa_admin/providers/slikaProfila_provider.dart';
import 'package:espa_admin/providers/statusRezervacije_provider.dart';
import 'package:espa_admin/providers/termin_provider.dart';
import 'package:espa_admin/providers/uloga_provider.dart';
import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/providers/zaposlenikSlike_provider.dart';
import 'package:espa_admin/providers/zaposlenik_provider.dart';
import 'package:espa_admin/providers/zaposlenikrecenzija_provider.dart';
import 'package:espa_admin/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*void main() {
  runApp(const MyApp());
}*/
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UslugaProvider()),
      ChangeNotifierProvider(create: (_) => KategorijaProvider()),
      ChangeNotifierProvider(create: (_) => NovostProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijaProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikProvider()),
      ChangeNotifierProvider(create: (_) => UlogaProvider()),
      ChangeNotifierProvider(create: (_) => StatusRezervacijeProvider()),
      ChangeNotifierProvider(create: (_) => NovostKomentarProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikUlogaProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikSlikeProvider()),
      ChangeNotifierProvider(create: (_) => TerminProvider()),
      ChangeNotifierProvider(create: (_) => KomentarProvider()),
      ChangeNotifierProvider(create: (_) => OcjenaProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ChangeNotifierProvider(create: (_) => SlikaProfilaProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikRecenzijaProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 7, 79, 34)),
        useMaterial3: false,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        // ostale rute...
      },
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
