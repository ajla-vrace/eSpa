// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorit _$FavoritFromJson(Map<String, dynamic> json) => Favorit(
      json['id'] as int?,
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['isFavorit'] as bool?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
    );

Map<String, dynamic> _$FavoritToJson(Favorit instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'isFavorit': instance.isFavorit,
      'datum': instance.datum?.toIso8601String(),
    };
