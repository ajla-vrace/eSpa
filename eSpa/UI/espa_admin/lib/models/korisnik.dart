import 'package:espa_admin/models/korisnikUloga.dart';
import 'package:espa_admin/models/slikaProfila.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? id;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  String? status;
  bool? isAdmin;
  bool? isBlokiran;
  DateTime? datumRegistracije;
  int? slikaId;
  SlikaProfila? slika;
  List<KorisnikUloga> korisnikUlogas;
  Korisnik(this.id,this.ime, this.prezime, this.email, this.telefon,this.korisnickoIme, this.status,this.isAdmin,this.isBlokiran,
  this.datumRegistracije, this.slikaId,this.slika,this.korisnikUlogas);

    /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Korisnik.fromJson(Map<String, dynamic> json) => _$KorisnikFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
