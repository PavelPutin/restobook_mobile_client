import 'package:json_annotation/json_annotation.dart';

part  'reservation.g.dart';

@JsonSerializable()
class Reservation {
  Reservation(
      this.id,
      this.personsNumber,
      this.clientPhoneNumber,
      this.clientName,
      this.startDateTime,
      this.durationIntervalMinutes,
      this.employeeFullName,
      this.creatingDateTime,
      this.state,
      this.comment,
      this.restaurantId,
      this.tableIds
      );

  int? id;
  int personsNumber;
  String clientPhoneNumber;
  String clientName;
  DateTime startDateTime;
  int durationIntervalMinutes;
  String employeeFullName;
  DateTime creatingDateTime;
  String? state; // OPEN, WAITING, CLOSED
  String? comment;
  int? restaurantId;
  List<int>? tableIds;

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}