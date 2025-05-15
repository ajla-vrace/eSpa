// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnikUloga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikUloga _$KorisnikUlogaFromJson(Map<String, dynamic> json) =>
    KorisnikUloga(
      json['id'] as int?,
      json['korisnikId'] as int?,
      json['ulogaId'] as int?,
      json['uloga'] == null
          ? null
          : Uloga.fromJson(json['uloga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KorisnikUlogaToJson(KorisnikUloga instance) =>
    <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'ulogaId': instance.ulogaId,
      'uloga': instance.uloga,
    };
