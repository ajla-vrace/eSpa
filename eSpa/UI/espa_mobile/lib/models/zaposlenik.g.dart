// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zaposlenik _$ZaposlenikFromJson(Map<String, dynamic> json) => Zaposlenik(
      json['id'] as int?,
      json['korisnikId'] as int?,
      json['datumZaposlenja'] == null
          ? null
          : DateTime.parse(json['datumZaposlenja'] as String),
      json['struka'] as String?,
      json['status'] as String?,
      json['napomena'] as String?,
      json['biografija'] as String?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['kategorijaId'] as int?,
      json['slikaId'] as int?,
      Kategorija.fromJson(json['kategorija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ZaposlenikToJson(Zaposlenik instance) =>
    <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'datumZaposlenja': instance.datumZaposlenja?.toIso8601String(),
      'struka': instance.struka,
      'status': instance.status,
      'napomena': instance.napomena,
      'biografija': instance.biografija,
      'korisnik': instance.korisnik,
      'kategorijaId': instance.kategorijaId,
      'slikaId': instance.slikaId,
      'kategorija': instance.kategorija,
    };
