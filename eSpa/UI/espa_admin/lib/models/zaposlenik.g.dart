// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zaposlenik _$ZaposlenikFromJson(Map<String, dynamic> json) => Zaposlenik(
      (json['id'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      json['datumZaposlenja'] == null
          ? null
          : DateTime.parse(json['datumZaposlenja'] as String),
      json['struka'] as String?,
      json['status'] as String?,
      json['napomena'] as String?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ZaposlenikToJson(Zaposlenik instance) =>
    <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'datumZaposlenja': instance.datumZaposlenja?.toIso8601String(),
      'struka': instance.struka,
      'status': instance.status,
      'napomena': instance.napomena,
      'korisnik': instance.korisnik,
    };
