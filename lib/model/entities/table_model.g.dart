// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
      json['id'] as int?,
      json['number'] as int,
      json['seatsNumber'] as int,
      json['state'] as String?,
      json['comment'] as String?,
      json['restaurantId'] as int?,
      (json['reservationIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TableModelToJson(TableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'seatsNumber': instance.seatsNumber,
      'state': instance.state,
      'comment': instance.comment,
      'restaurantId': instance.restaurantId,
      'reservationIds': instance.reservationIds,
    };
