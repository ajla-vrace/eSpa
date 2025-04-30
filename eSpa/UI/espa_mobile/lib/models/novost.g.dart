// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
      (json['id'] as num?)?.toInt(),
      json['naslov'] as String?,
      json['sadrzaj'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      (json['autorId'] as num?)?.toInt(),
      json['status'] as String?,
      json['slika'] as String?,
      json['autor'] == null
          ? null
          : Korisnik.fromJson(json['autor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
      'id': instance.id,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'autorId': instance.autorId,
      'status': instance.status,
      'slika': instance.slika,
      'autor': instance.autor,
    };
