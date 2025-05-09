// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uslugaOcjena.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UslugaOcjena _$UslugaOcjenaFromJson(Map<String, dynamic> json) => UslugaOcjena(
      (json['uslugaId'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['sifra'] as String?,
      (json['prosjecnaOcjena'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UslugaOcjenaToJson(UslugaOcjena instance) =>
    <String, dynamic>{
      'uslugaId': instance.uslugaId,
      'naziv': instance.naziv,
      'sifra': instance.sifra,
      'prosjecnaOcjena': instance.prosjecnaOcjena,
    };
