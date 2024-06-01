import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_mobile_client/model/entities/table_model.dart';
import 'package:restobook_mobile_client/model/repository/abstract_table_repository.dart';
import 'package:restobook_mobile_client/model/repository/mock_backend.dart';
import 'package:restobook_mobile_client/model/utils/utils.dart';

import '../entities/reservation.dart';
import '../service/api_dio.dart';

class HttpTablesRepository extends AbstractTableRepository {

  final List<TableModel> _tables = GetIt.I<MockBackend>().tables;
  final List<Reservation> _reservations = GetIt.I<MockBackend>().reservations;

  final api = GetIt.I<Api>();
  final logger = GetIt.I<Logger>();

  @override
  Future<TableModel> create(int restaurantId, TableModel table) async {
    // return ConnectionSimulator<TableModel>().connect(() {
    //   int maxId = 0;
    //   for (var t in _tables) {
    //     if (t.id! > maxId) {
    //       maxId = t.id!;
    //     }
    //   }
    //   table.id = maxId + 1;
    //   table.state = "NORMAL";
    //   table.restaurantId = 1;
    //   _tables.add(table);
    //   return table;
    // });
    try {
      logger.t("Try create table");
      table.restaurantId = restaurantId;
      final response = await api.dio.post(
        "/restobook-api/table/$restaurantId/table",
        data: table
      );
      TableModel created = TableModel.fromJson(response.data);
      logger.t("Created table\n$created");
      return created;
    } on DioException catch (e) {
      logger.e("Can't create table", error: e);
      rethrow;
    }
  }

  @override
  Future<void> delete(TableModel table) {
    for (int reservationId in table.reservationIds!) {
      for (var reservation in _reservations) {
        if (reservation.id! == reservationId) {
          if (reservation.tableIds?.length == 1) {
            throw Exception("Нельзя удалить стол, так как он единственный для брони");
          }
          reservation.tableIds?.remove(table.id!);
        }
      }
    }
    return ConnectionSimulator<void>().connect(() => _tables.remove(table));
  }

  @override
  Future<List<TableModel>> getAll() {
    return ConnectionSimulator<List<TableModel>>().connect(() => _tables);
  }

  @override
  Future<TableModel> getById(int id) {
    return ConnectionSimulator<TableModel>().connect(() {
      for (var table in _tables) {
        if (table.id == id) {
          return table;
        }
      }
      throw Exception("Стол не найден");
    });
  }

  @override
  Future<TableModel> update(TableModel table) {
    return ConnectionSimulator<TableModel>().connect(() {
      for (int i = 0; i < _tables.length; i++) {
        if (_tables[i].id == table.id) {
          _tables[i] = table;
          return table;
        }
      }
      throw Exception("Стол не найден");
    });
  }
}