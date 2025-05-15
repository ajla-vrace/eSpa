// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      json['id'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['korisnickoIme'] as String?,
      json['status'] as String?,
      json['isAdmin'] as bool?,
      json['isZaposlenik'] as bool?,
      json['isBlokiran'] as bool?,
      json['datumRegistracije'] == null
          ? null
          : DateTime.parse(json['datumRegistracije'] as String),
      json['slikaId'] as int?,
      json['slika'] == null
          ? null
          : SlikaProfila.fromJson(json['slika'] as Map<String, dynamic>),
      (json['korisnikUlogas'] as List<dynamic>)
          .map((e) => KorisnikUloga.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'id': instance.id,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnickoIme': instance.korisnickoIme,
      'status': instance.status,
      'isAdmin': instance.isAdmin,
      'isZaposlenik': instance.isZaposlenik,
      'isBlokiran': instance.isBlokiran,
      'datumRegistracije': instance.datumRegistracije?.toIso8601String(),
      'slikaId': instance.slikaId,
      'slika': instance.slika,
      'korisnikUlogas': instance.korisnikUlogas,
    };
