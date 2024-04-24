// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      json['id'] as int?,
      json['personsNumber'] as int,
      json['clientPhoneNumber'] as String,
      json['clientName'] as String,
      DateTime.parse(json['startDateTime'] as String),
      json['durationIntervalMinutes'] as int,
      json['employeeFullName'] as String,
      DateTime.parse(json['creatingDateTime'] as String),
      json['state'] as String?,
      json['comment'] as String?,
      json['restaurantId'] as int?,
      (json['tableIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personsNumber': instance.personsNumber,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'clientName': instance.clientName,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'durationIntervalMinutes': instance.durationIntervalMinutes,
      'employeeFullName': instance.employeeFullName,
      'creatingDateTime': instance.creatingDateTime.toIso8601String(),
      'state': instance.state,
      'comment': instance.comment,
      'restaurantId': instance.restaurantId,
      'tableIds': instance.tableIds,
    };
