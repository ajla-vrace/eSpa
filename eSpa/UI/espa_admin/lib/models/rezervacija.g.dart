// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija(
      json['id'] as int?,
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['terminId'] as int?,
      json['status'] as String?,
      json['napomena'] as String?,
      json['isPlaceno'] as bool?,
      json['statusRezervacijeId'] as int?,
      json['statusRezervacije'] == null
          ? null
          : StatusRezervacije.fromJson(
              json['statusRezervacije'] as Map<String, dynamic>),
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
      'status': instance.status,
      'napomena': instance.napomena,
      'isPlaceno': instance.isPlaceno,
      'statusRezervacijeId': instance.statusRezervacijeId,
      'statusRezervacije': instance.statusRezervacije,
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
      'termin': instance.termin,
      'zaposlenik': instance.zaposlenik,
    };
