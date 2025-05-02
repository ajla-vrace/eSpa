// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novostKomentar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovostKomentar _$NovostKomentarFromJson(Map<String, dynamic> json) =>
    NovostKomentar(
      (json['id'] as num?)?.toInt(),
      json['sadrzaj'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      (json['novostId'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['novost'] == null
          ? null
          : Novost.fromJson(json['novost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostKomentarToJson(NovostKomentar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sadrzaj': instance.sadrzaj,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'novostId': instance.novostId,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
      'novost': instance.novost,
    };
