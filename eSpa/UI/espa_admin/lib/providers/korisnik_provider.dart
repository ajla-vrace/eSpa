import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnici");

  Future<Korisnik> blokirajKorisnika(int korisnikId) async {
    // Prvo preuzimamo sve podatke o korisniku koristeći njegov ID
    // Ovdje pretpostavljam da postoji metoda za dohvat korisnika po ID-u
    var korisnik = await get(filter: {'id': korisnikId});
    if (korisnik.result.isEmpty) {
      throw Exception("Korisnik nije pronađen");
    }
    // Zatim ažuriramo njegov status u "blokiran"
    var request = {
      "id": korisnik.result[0].id, // Pretpostavljam da korisnik ima atribut id
      "status": "blokiran",
      "ime": korisnik.result[0].ime,
      "prezime": korisnik.result[0].prezime,
      "email": korisnik.result[0].email,
      "telefon":
          korisnik.result[0].telefon, // Pretpostavljamo da korisnik ima status
      // Dodaj ostale atribute korisnika koje želiš poslati u update
    };

    // Pozivamo metodu za ažuriranje korisnika
    return await update(korisnikId, request);
  }

  @override
  Korisnik fromJson(data) {
    // TODO: implement fromJson
    return Korisnik.fromJson(data);
  }
}
