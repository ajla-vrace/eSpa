import 'package:espa_admin/models/rezervacija.dart';
import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/rezervacija_provider.dart';
import 'package:espa_admin/providers/statusRezervacije_provider.dart';
import 'package:espa_admin/screens/rezervacije.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/statusRezervacije.dart';

// ignore: must_be_immutable
class RezervacijaDetaljiPage extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijaDetaljiPage({Key? key, this.rezervacija}) : super(key: key);

  @override
  State<RezervacijaDetaljiPage> createState() => _RezervacijaDetaljiPageState();
}

class _RezervacijaDetaljiPageState extends State<RezervacijaDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late RezervacijaProvider _rezervacijaProvider;

  SearchResult<Rezervacija>? rezervacijaResult;
  bool isLoading = true;

  late DateTime datumRezervacije; // Datum rezervacije
  late String terminPocetak;

  String? selectedStatus; // Početak termina
  List<StatusRezervacije> _statusi = [];
  String? _selectedStatus = 'Sve';

  late StatusRezervacijeProvider
      _statusRezervacijeProvider; // Po defaultu "Sve"

  // Funkcija za provjeru da li je termin prošao
  bool isTerminProsao(DateTime datum, String pocetak) {
    Duration pocetakDuration = timeStringToDuration(pocetak);
    DateTime terminDatum = datum.add(pocetakDuration);
    return terminDatum.isBefore(DateTime.now()); // Ako je termin prošao
  }

  // Pretvori String u Duration
  Duration timeStringToDuration(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }

  //List<String> statusi = ['Aktivna', 'Otkazana', 'Zavrsena'];

  @override
  void initState() {
    super.initState();
    _initialValue = {
      //'naslov': widget.novost?.naslov,
      // 'sadrzaj': widget.novost?.sadrzaj,
      // 'datumKreiranja': widget.novost?.datumKreiranja,
      //'korisnickoIme': widget.rezervacija?.korisnik.korisnickoIme,
      'status': widget.rezervacija?.status,
    };

    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _statusRezervacijeProvider = context.read<StatusRezervacijeProvider>();

    datumRezervacije = widget.rezervacija!.datum!; // Datum iz rezervacije
    terminPocetak =
        widget.rezervacija!.termin!.pocetak!; // Vreme početka termina
    // selectedStatus = widget.rezervacija?.status; // Trenutni status rezervacije
    _loadStatusi();
    initForm();
    print("status $_initialValue");

    // Ako je termin prošao, ukloni "Otkazana" iz liste
    /*if (isTerminProsao(datumRezervacije, terminPocetak)) {
      print("otkazana remove");
      statusi.remove('Otkazana');
    } else {
      print("zavrsena remove");
      statusi.remove('Zavrsena');
    }*/ //////OVDJE BITNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
  }

  Future initForm() async {
    rezervacijaResult = await _rezervacijaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadRezervacije() async {
    var _isReezrvacijaLoading;
    try {
      final rezervacije =
          await Provider.of<RezervacijaProvider>(context, listen: false).get();
      setState(() {
        final _rezervacije = rezervacije.result;
        _isReezrvacijaLoading = false;
      });
    } catch (e) {
      setState(() {
        _isReezrvacijaLoading = false;
      });
    }
  }

  Future<void> _loadStatusi() async {
    try {
      var result = await _statusRezervacijeProvider.get(); // poziv API-ja
      setState(() {
        _statusi = result.result; // pretpostavka: API vraća Paginated listu
        print("Statusi $_statusi");
      });
    } catch (e) {
      print("Greška prilikom dohvata statusa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Početna lista statusa koja sadrži "Aktivna" i "Otkazana"

    return MasterScreenWidget(
      // Ostatak sadržaja dolazi iz MasterScreenWidget-a
      // ignore: sort_child_properties_last
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(160.0), // Odmicanje od ivica ekrana
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          


            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Sprečava prekomerno širenje
                children: [
                  // Red sa naslovom i X dugmetom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                      Spacer(), // Gura dugme skroz desno
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black54),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  isLoading ? const CircularProgressIndicator() : _buildForm(),
                  const SizedBox(height: 20),

                  // Dugmad za navigaciju
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RezervacijePage()),
                          );
                        },
                        child: const Text("Nazad"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                      ),
                     
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      title: /*this.widget.novost?.naslov ??*/ "Rezervacija detalji",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
        
          _buildStatusDropdownField(
              "Status rezervacije", "statusRezervacijeId"),

          SizedBox(height: 10),
        ],
      ),
    );
  }



  Widget _buildStatusDropdownField(String label, String name) {
    if (widget.rezervacija == null) {
      return SizedBox.shrink();
    }

    // Prethodna vrednost statusa pre nego što se dijalog otvori
    final previousValue =
        _initialValue[name] ?? widget.rezervacija?.statusRezervacijeId;

    return FormBuilderDropdown<int>(
      name: name,
      initialValue: previousValue, // Početna vrednost
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.check_circle_outline),
        border: OutlineInputBorder(),
      ),
      items: _statusi.map<DropdownMenuItem<int>>((status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Text(status.naziv ?? ''),
        );
      }).toList(),
      onChanged: (value) async {
        // Ako je izabrani status isti kao prethodni, ne treba ništa da se menja
        if (value == null || value == _initialValue[name]) return;

        final selectedStatus = _statusi.firstWhere(
          (s) => s.id == value,
        );

        // Ako korisnik odabere "Aktivna" (pretpostavljam da je ovo id za "Aktivna" status)
        if (selectedStatus.naziv == 'Aktivna') {
          // Ako je izabran status "Aktivna", ništa se ne menja, preskačemo dijalog
          return;
        }

        // Pokaži dijalog za potvrdu samo ako status nije "Aktivna"
        bool? potvrda = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Potvrda"),
            content: Text(
                "Jeste li sigurni da želite promijeniti status u '${selectedStatus.naziv}'?"),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[400], 
                ),
                onPressed: () {
                  // Ako korisnik odustane, navigiraj na ekran sa svim rezervacijama
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RezervacijePage(),
                    ),
                  );
                },
                child: Text("Ne"),
              ),
              TextButton(
                onPressed: () async {
                  // Ako korisnik potvrdi, postavljamo novu vrednost i spremamo status u bazi
                  setState(() {
                    _initialValue[name] = value; // Vraćamo novu vrednost
                  });

                  // Kreiraj objekat sa podacima za update
                  var request = {
                    'statusRezervacijeId': value,
                    // Dodaj ostale potrebne podatke za update (ako ih ima)
                  };

                  // Poziv za update statusa u bazi
                  await _rezervacijaProvider.update(
                      widget.rezervacija!.id!, request);

                  // Prikazivanje uspešne poruke
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Rezervacija uspješno modifikovana.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.green, // Zeleni background
                      behavior:
                          SnackBarBehavior.floating, // Opcionalno lepši prikaz
                      duration: Duration(seconds: 3),
                    ),
                  );

                  // Zatvori dijalog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RezervacijePage(),
                    ),
                  );
                },
                child: Text("Da"),
              ),
            ],
          ),
        );
      },
    );
  }


}
