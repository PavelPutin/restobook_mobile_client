// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
      json['id'] as int?,
      json['number'] as int,
      json['seatsNumber'] as int,
      json['state'] as String?,
      json['restaurantId'] as int?,
      (json['reservationIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'seatsNumber': instance.seatsNumber,
      'state': instance.state,
      'restaurantId': instance.restaurantId,
      'reservationIds': instance.reservationIds,
    };
