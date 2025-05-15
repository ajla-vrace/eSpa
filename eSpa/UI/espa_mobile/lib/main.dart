import 'package:espa_mobile/providers/favorit_provider.dart';
import 'package:espa_mobile/providers/kategorija_provider.dart';
import 'package:espa_mobile/providers/komentar_provider.dart';
import 'package:espa_mobile/providers/korisnikUloga_provider.dart';
import 'package:espa_mobile/providers/korisnik_provider.dart';
import 'package:espa_mobile/providers/novostInterakcija_provider.dart';
import 'package:espa_mobile/providers/novostKomentar_provider.dart';
import 'package:espa_mobile/providers/novost_provider.dart';
import 'package:espa_mobile/providers/ocjena_provider.dart';
import 'package:espa_mobile/providers/rezervacija_provider.dart';
import 'package:espa_mobile/providers/statusRezervacije_provider.dart';
import 'package:espa_mobile/providers/termin_provider.dart';
import 'package:espa_mobile/providers/uloga_provider.dart';
import 'package:espa_mobile/providers/usluga_provider.dart';
import 'package:espa_mobile/providers/zaposlenikRecenzija_provider.dart';
import 'package:espa_mobile/providers/zaposlenikSlika_provider.dart';
import 'package:espa_mobile/providers/zaposlenik_provider.dart';
import 'package:espa_mobile/screens/home.dart';
import 'package:espa_mobile/screens/login.dart';
import 'package:espa_mobile/screens/pretraga.dart';
import 'package:espa_mobile/screens/profil.dart';
import 'package:espa_mobile/screens/rezervacije.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*void main() {
  runApp(const MyApp());
}*/
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => KategorijaProvider()),
      ChangeNotifierProvider(create: (_) => NovostProvider()),
      ChangeNotifierProvider(create: (_) => KomentarProvider()),
      ChangeNotifierProvider(create: (_) => OcjenaProvider()),
      ChangeNotifierProvider(create: (_) => StatusRezervacijeProvider()),
      ChangeNotifierProvider(create: (_) => NovostKomentarProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikRecenzijaProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikUlogaProvider()),
      ChangeNotifierProvider(create: (_) => UlogaProvider()),
      ChangeNotifierProvider(create: (_) => UslugaProvider()),
      ChangeNotifierProvider(create: (_) => FavoritProvider()),
      ChangeNotifierProvider(create: (_) => TerminProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijaProvider()),
      ChangeNotifierProvider(create: (_) => NovostInterakcijaProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikSlikeProvider()),
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 7, 79, 34)),
        useMaterial3: false,
      ),
      routes: {
        // Početna stranica (npr. HomePage)
        '/login': (context) => LoginPage(),
        '/rezervacije': (context) =>
            RezervacijeScreen(), // Ovdje definiraš login rutu
        '/pretraga': (context) => PretragaScreen(),
        '/home': (context) => HomeScreen(),
        '/profil': (context) => KorisnickiProfilScreen(),
        // Dodaj sve druge rute ovde
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigacija na ekran sa kategorijama
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Prikazivanje Kategorija'),
            ),
            const Text(
              'Ovo je moja prva flutter mobilna.',
            ),
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
