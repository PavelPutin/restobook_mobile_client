import 'package:restobook_mobile_client/model/model.dart';

class MockBackend {
  List<Employee> get employee => _employees;
  final List<Employee> _employees = List.from([
    Employee(
        1,
        "frolov_m_vR1",
        "Фролов",
        "Макар",
        null,
        "Лучший сотрудник!",
        true,
        1
    ),
    Employee(
        2,
        "pupkin_v_pR1",
        "Пупкин",
        "Василий",
        "Петрович",
        "стажёр",
        false,
        1
    ),
    Employee(
        3,
        "putin_p_a",
        "Путин",
        "Павел",
        "Александрович",
        "администратор",
        false,
        1
    )
  ]);

  List<Reservation> get reservations => _reservations;
  final List<Reservation> _reservations = List.from([
    Reservation(
        1,
        2,
        "+79007629931",
        "Василий",
        DateTime.utc(2024, 4, 28, 13, 00, 00),
        60,
        "Фролов Макар Викторович",
        DateTime.utc(2024, 4, 19, 17, 54, 32),
        "WAITING",
        "Юбилей",
        1,
        List.from([1])
    ),
    Reservation(
        2,
        3,
        "+79217629932",
        "Анатолий",
        DateTime.utc(2024, 4, 20, 17, 00, 00),
        60,
        "Фролов Макар Викторович",
        DateTime.utc(2024, 4, 19, 18, 17, 32),
        "WAITING",
        null,
        1,
        List.from([1, 2])
    ),
  ]);

  List<TableModel> get tables => _tables;
  final List<TableModel> _tables = List.from([
    TableModel(1, 1, 2, "NORMAL", "Столик у бара", 1, List.from([1])),
    TableModel(2, 2, 1, "BROKEN", null, 1, List.from([1, 2])),
  ]);
}