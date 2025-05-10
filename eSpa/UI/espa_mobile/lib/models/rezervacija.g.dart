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
      (json['zaposlenikId'] as num?)?.toInt(),
      json['status'] as String?,
      json['isPlaceno'] as bool?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
      json['termin'] == null
          ? null
          : Termin.fromJson(json['termin'] as Map<String, dynamic>),
      json['zaposlenik'] == null
          ? null
          : Zaposlenik.fromJson(json['zaposlenik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'datum': instance.datum?.toIso8601String(),
      'terminId': instance.terminId,
      'zaposlenikId': instance.zaposlenikId,
      'status': instance.status,
      'isPlaceno': instance.isPlaceno,
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
      'termin': instance.termin,
      'zaposlenik': instance.zaposlenik,
    };
