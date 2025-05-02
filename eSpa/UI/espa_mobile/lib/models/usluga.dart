import 'package:espa_mobile/models/kategorija.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'usluga.g.dart';

@JsonSerializable()
class Usluga {
  int? id;
  String? naziv;
  String? opis;
  double? cijena;
  String? trajanje;
  int? kategorijaId;
  String? slika;
  Kategorija kategorija;
  Usluga(this.id, this.naziv, this.opis, this.cijena, this.trajanje, this.kategorijaId,this.slika,this.kategorija);

    /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Usluga.fromJson(Map<String, dynamic> json) => _$UslugaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UslugaToJson(this);
}
