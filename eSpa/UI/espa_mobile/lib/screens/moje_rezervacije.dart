import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espa_mobile/models/rezervacija.dart';
import 'package:espa_mobile/providers/rezervacija_provider.dart';
import 'package:espa_mobile/widgets/master_screen.dart';
import 'package:espa_mobile/utils/util.dart';

class MojeRezervacijeScreen extends StatefulWidget {
  const MojeRezervacijeScreen({super.key});

  @override
  State<MojeRezervacijeScreen> createState() => _MojeRezervacijeScreenState();
}

class _MojeRezervacijeScreenState extends State<MojeRezervacijeScreen> {
  List<Rezervacija> rezervacije = [];
  bool isLoading = true;
  int brojRezervacija = 0;

  String formatTime(String? time) {
    if (time == null || !time.contains(":")) return "Nepoznato";
    return time.substring(0, 5); // npr. 11:00
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
        rezervacije = data.result;
        brojRezervacija = data.count;
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
      title:"Moje rezervacije",
      selectedIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Moje rezervacije',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Ukupno rezervacija: $brojRezervacija',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (rezervacije.isEmpty)
              const Center(
                child: Text(
                  "Nemate nijednu rezervaciju.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
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
                      leading: const Icon(Icons.event_note,
                          color: Colors.green, size: 28),
                      title: Text(
                        rezervacija.usluga?.naziv ?? "Nepoznata usluga",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            "Datum: ${formatDate(rezervacija.datum)}",
                          ),
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
