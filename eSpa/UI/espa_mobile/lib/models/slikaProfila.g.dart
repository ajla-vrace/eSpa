// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slikaProfila.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlikaProfila _$SlikaProfilaFromJson(Map<String, dynamic> json) => SlikaProfila(
      json['id'] as int?,
      json['naziv'] as String?,
      json['slika'] as String?,
      json['tip'] as String?,
      json['datumPostavljanja'] == null
          ? null
          : DateTime.parse(json['datumPostavljanja'] as String),
    );

Map<String, dynamic> _$SlikaProfilaToJson(SlikaProfila instance) =>
    <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'slika': instance.slika,
      'tip': instance.tip,
      'datumPostavljanja': instance.datumPostavljanja?.toIso8601String(),
    };
