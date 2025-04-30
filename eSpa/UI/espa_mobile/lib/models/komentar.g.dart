// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentar _$KomentarFromJson(Map<String, dynamic> json) => Komentar(
      (json['id'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      (json['uslugaId'] as num?)?.toInt(),
      json['tekst'] as String?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KomentarToJson(Komentar instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'tekst': instance.tekst,
      'datum': instance.datum?.toIso8601String(),
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
    };
