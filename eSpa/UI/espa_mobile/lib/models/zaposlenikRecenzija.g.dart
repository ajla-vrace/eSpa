// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenikRecenzija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZaposlenikRecenzija _$ZaposlenikRecenzijaFromJson(Map<String, dynamic> json) =>
    ZaposlenikRecenzija(
      json['id'] as int?,
      json['komentar'] as String?,
      json['ocjena'] as int?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['zaposlenikId'] as int?,
      json['korisnikId'] as int?,
      json['zaposlenik'] == null
          ? null
          : Zaposlenik.fromJson(json['zaposlenik'] as Map<String, dynamic>),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ZaposlenikRecenzijaToJson(
        ZaposlenikRecenzija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'komentar': instance.komentar,
      'ocjena': instance.ocjena,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'zaposlenikId': instance.zaposlenikId,
      'korisnikId': instance.korisnikId,
      'zaposlenik': instance.zaposlenik,
      'korisnik': instance.korisnik,
    };
