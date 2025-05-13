import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/models/novostInterakcija.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'novost.g.dart';

@JsonSerializable()
class Novost {
  int? id;
  String? naslov;
  String? sadrzaj;
  DateTime? datumKreiranja;
  int? autorId;
  String? status;
  String? slika;
  Korisnik? autor;
  List<NovostInterakcija>? novostInterakcijas;
  Novost(this.id, this.naslov, this.sadrzaj, this.datumKreiranja,this.autorId, this.status, this.slika, this.autor);

    /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Novost.fromJson(Map<String, dynamic> json) => _$NovostFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NovostToJson(this);
}
