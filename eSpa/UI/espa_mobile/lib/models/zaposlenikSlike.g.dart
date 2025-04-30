// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenikSlike.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZaposlenikSlike _$ZaposlenikSlikeFromJson(Map<String, dynamic> json) =>
    ZaposlenikSlike(
      (json['id'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['slika'] as String?,
      json['tip'] as String?,
      json['datumPostavljanja'] == null
          ? null
          : DateTime.parse(json['datumPostavljanja'] as String),
    );

Map<String, dynamic> _$ZaposlenikSlikeToJson(ZaposlenikSlike instance) =>
    <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'slika': instance.slika,
      'tip': instance.tip,
      'datumPostavljanja': instance.datumPostavljanja?.toIso8601String(),
    };
