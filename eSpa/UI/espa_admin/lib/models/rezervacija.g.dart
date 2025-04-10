// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija(
      (json['id'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      (json['uslugaId'] as num?)?.toInt(),
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      (json['terminId'] as num?)?.toInt(),
      json['status'] as String?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
      json['termin'] == null
          ? null
          : Termin.fromJson(json['termin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'datum': instance.datum?.toIso8601String(),
      'terminId': instance.terminId,
      'status': instance.status,
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
      'termin': instance.termin,
    };
