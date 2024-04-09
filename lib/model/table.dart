import 'package:json_annotation/json_annotation.dart';

part 'table.g.dart';

@JsonSerializable()
class Table {
  Table(this.id,
      this.number,
      this.seatsNumber,
      this.state,
      this.restaurantId,
      this.reservationIds
      );

  int? id;
  int number;
  int seatsNumber;
  String? state;
  int? restaurantId;
  List<int>? reservationIds;

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
  Map<String, dynamic> toJson() => _$TableToJson(this);
}