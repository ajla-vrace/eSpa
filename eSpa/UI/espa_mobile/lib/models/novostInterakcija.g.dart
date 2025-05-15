// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novostInterakcija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovostInterakcija _$NovostInterakcijaFromJson(Map<String, dynamic> json) =>
    NovostInterakcija(
      json['id'] as int?,
      json['novostId'] as int?,
      json['korisnikId'] as int?,
      json['isLiked'] as bool?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
    );

Map<String, dynamic> _$NovostInterakcijaToJson(NovostInterakcija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'novostId': instance.novostId,
      'korisnikId': instance.korisnikId,
      'isLiked': instance.isLiked,
      'datum': instance.datum?.toIso8601String(),
    };
