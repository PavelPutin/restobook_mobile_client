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
        "/restobook-api/restaurant/$restaurantId/table",
        data: table.toJson()
      );

      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }

      TableModel created = TableModel.fromJson(response.data);
      logger.t("Created table\n${created.toJson()}");
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
  Future<List<TableModel>> getAll(int restaurantId) async {
    // return ConnectionSimulator<List<TableModel>>().connect(() => _tables);
    try {
      logger.t("Try get all tables");
      final response = await api.dio.get(
          "/restobook-api/restaurant/$restaurantId/table"
      );

      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }

      List<TableModel> result = [];
      for (var e in response.data) {
        result.add(TableModel.fromJson(e));
      }
      logger.t("Get all tables");
      return result;
    } on DioException catch (e) {
      logger.e("Can't get all tables", error: e);
      rethrow;
    } catch (e) {
      logger.e("Can't get all tables", error: e);
      rethrow;
    }
  }

  @override
  Future<TableModel> getById(int restaurantId, int id) async {
    // return ConnectionSimulator<TableModel>().connect(() {
    //   for (var table in _tables) {
    //     if (table.id == id) {
    //       return table;
    //     }
    //   }
    //   throw Exception("Стол не найден");
    // });
    try {
      logger.t("Try get table $id");
      final response = await api.dio.get(
          "/restobook-api/restaurant/$restaurantId/table/$id"
      );
      TableModel fetched = TableModel.fromJson(response.data);
      logger.t("Fetched table\n${fetched.toJson()}");
      return fetched;
    } on DioException catch (e) {
      logger.e("Can't get table $id", error: e);
      rethrow;
    } catch (e) {
      logger.e("Can't get table $id", error: e);
      rethrow;
    }
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