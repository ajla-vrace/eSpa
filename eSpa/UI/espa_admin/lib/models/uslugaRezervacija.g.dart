// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uslugaRezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UslugaRezervacija _$UslugaRezervacijaFromJson(Map<String, dynamic> json) =>
    UslugaRezervacija(
      (json['uslugaId'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['sifra'] as String?,
      (json['brojRezervacija'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UslugaRezervacijaToJson(UslugaRezervacija instance) =>
    <String, dynamic>{
      'uslugaId': instance.uslugaId,
      'naziv': instance.naziv,
      'sifra': instance.sifra,
      'brojRezervacija': instance.brojRezervacija,
    };
