import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/repository/mock_employee_repository.dart';
import 'package:restobook_mobile_client/model/repository/mock_reservations_repository.dart';
import 'package:restobook_mobile_client/view/main_screen/main_screen.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

void main() {
  AppMetrica.runZoneGuarded(() {
    AppMetrica.activate(const AppMetricaConfig(String.fromEnvironment("AppMetricaKey")));

    GetIt.I.registerSingleton<AbstractTableRepository>(MockTablesRepository());
    GetIt.I.registerSingleton<AbstractReservationRepository>(MockReservationsRepository());
    GetIt.I.registerSingleton<AbstractEmployeeRepository>(MockEmployeeRepository());

    FlutterError.onError =
        (details) => print(details);

    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => EmployeeViewModel()),
            ChangeNotifierProvider(create: (context) => ReservationViewModel()),
            ChangeNotifierProvider(create: (context) => TableViewModel())
          ],
          child: const MyApp()
        )
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ru')
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
