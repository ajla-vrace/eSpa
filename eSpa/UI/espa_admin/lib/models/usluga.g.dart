// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usluga _$UslugaFromJson(Map<String, dynamic> json) => Usluga(
      (json['id'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['opis'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['trajanje'] as String?,
      (json['kategorijaId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UslugaToJson(Usluga instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'cijena': instance.cijena,
      'trajanje': instance.trajanje,
      'kategorijaId': instance.kategorijaId,
    };
