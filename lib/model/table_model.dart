import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

@JsonSerializable()
class TableModel {
  TableModel(this.id,
      this.number,
      this.seatsNumber,
      this.state,
      this.comment,
      this.restaurantId,
      this.reservationIds
      );

  int? id;
  int number;
  int seatsNumber;
  String? state;
  String? comment;
  int? restaurantId;
  List<int>? reservationIds;

  factory TableModel.fromJson(Map<String, dynamic> json) => _$TableModelFromJson(json);
  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}