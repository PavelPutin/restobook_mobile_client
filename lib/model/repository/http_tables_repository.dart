import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_mobile_client/model/entities/table_model.dart';
import 'package:restobook_mobile_client/model/repository/abstract_table_repository.dart';

import '../service/api_dio.dart';

class HttpTablesRepository extends AbstractTableRepository {
  final api = GetIt.I<Api>();
  final logger = GetIt.I<Logger>();

  @override
  Future<TableModel> create(int restaurantId, TableModel table) async {
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
  Future<void> delete(int restaurantId, TableModel table) async {
    try {
      logger.t("Try delete table ${table.id}");
      await api.dio.delete(
          "/restobook-api/restaurant/$restaurantId/table/${table.id}"
      );
      logger.t("Deleted table");
    } on DioException catch (e) {
      logger.e("Can't delete table ${table.id}", error: e);
      rethrow;
    } catch (e) {
      logger.e("Can't delete table ${table.id}", error: e);
      rethrow;
    }
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
  Future<TableModel> update(int restaurantId, TableModel table) async {
    try {
      logger.t("Try update table");
      table.restaurantId = restaurantId;
      final response = await api.dio.put(
          "/restobook-api/restaurant/$restaurantId/table/${table.id!}",
          data: table.toJson()
      );

      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }

      TableModel updated = TableModel.fromJson(response.data);
      logger.t("Updated table\n${updated.toJson()}");
      return updated;
    } on DioException catch (e) {
      logger.e("Can't update table", error: e);
      rethrow;
    } catch (e) {
      logger.e("Can't update table", error: e);
      rethrow;
    }
  }
}