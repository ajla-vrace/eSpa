// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usluga _$UslugaFromJson(Map<String, dynamic> json) => Usluga(
      json['id'] as int?,
      json['naziv'] as String?,
      json['opis'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['trajanje'] as String?,
      json['kategorijaId'] as int?,
      json['slika'] as String?,
      Kategorija.fromJson(json['kategorija'] as Map<String, dynamic>),
      (json['favorits'] as List<dynamic>?)
          ?.map((e) => Favorit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UslugaToJson(Usluga instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'cijena': instance.cijena,
      'trajanje': instance.trajanje,
      'kategorijaId': instance.kategorijaId,
      'slika': instance.slika,
      'kategorija': instance.kategorija,
      'favorits': instance.favorits,
    };
