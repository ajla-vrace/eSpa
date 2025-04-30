import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/models/rezervacija.dart';
import 'package:espa_mobile/providers/rezervacija_provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:espa_mobile/utils/util.dart';

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({super.key});

  @override
  State<RezervacijeScreen> createState() => _RezervacijeScreenState();
}

class _RezervacijeScreenState extends State<RezervacijeScreen> {
  List<Rezervacija> rezervacije = [];
  bool isLoading = true;

  String formatTime(String? time) {
    if (time == null || !time.contains(":")) return "Nepoznato";
    return time.substring(0, 5);
  }

  @override
  void initState() {
    super.initState();
    _loadRezervacije();
  }

  Future<void> _loadRezervacije() async {
    final korisnickoIme = await getUserName();
    if (korisnickoIme != null) {
      final rezervacijaProvider = context.read<RezervacijaProvider>();
      final data = await rezervacijaProvider.get(filter: {
        'korisnik': korisnickoIme,
      });

      setState(() {
        rezervacije = data.result
            .where((r) => r.status?.toLowerCase() == 'aktivna')
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title:"Rezervacije",
      selectedIndex: 2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Aktivne rezervacije',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Ukupno aktivnih: ${rezervacije.length}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (rezervacije.isEmpty)
              const Center(
                child: Text(
                  "Nemate nijednu aktivnu rezervaciju.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            //const Text("Nemate nijednu aktivnu rezervaciju.")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rezervacije.length,
                itemBuilder: (context, index) {
                  final rezervacija = rezervacije[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: const Icon(Icons.event_available,
                          color: Color.fromARGB(255, 33, 59, 35), size: 28),
                      title: Text(
                        rezervacija.usluga?.naziv ?? "Nepoznata usluga",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Datum: ${formatDate(rezervacija.datum)}"),
                          Text(
                              "Vrijeme: ${formatTime(rezervacija.termin?.pocetak)}"),
                          const SizedBox(height: 4),
                          Text(
                            "Status: ${rezervacija.status ?? 'Nepoznat'}",
                            style: TextStyle(
                              color: getStatusColor(rezervacija.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Nepoznato";
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}.";
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'aktivna':
        return Colors.green;
      case 'završena':
        return Colors.blue;
      case 'otkazana':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
