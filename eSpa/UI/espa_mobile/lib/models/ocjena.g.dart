// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjena.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ocjena _$OcjenaFromJson(Map<String, dynamic> json) => Ocjena(
      json['id'] as int?,
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['ocjena1'] as int?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OcjenaToJson(Ocjena instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'ocjena1': instance.ocjena1,
      'datum': instance.datum?.toIso8601String(),
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
    };
