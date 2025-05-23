import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/models/usluga.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'komentar.g.dart';

@JsonSerializable()
class Komentar {
  int? id;
  int? korisnikId;
  int? uslugaId;
  String? tekst;
  DateTime? datum;
  Korisnik? korisnik;
  Usluga? usluga;
  Komentar(this.id, this.korisnikId, this.uslugaId, this.tekst, this.datum, this.korisnik,this.usluga);

    /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Komentar.fromJson(Map<String, dynamic> json) => _$KomentarFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KomentarToJson(this);
}
