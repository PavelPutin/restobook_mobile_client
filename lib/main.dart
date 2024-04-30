import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/repository/mock_backend.dart';
import 'package:restobook_mobile_client/model/repository/mock_employee_repository.dart';
import 'package:restobook_mobile_client/model/repository/mock_reservations_repository.dart';
import 'package:restobook_mobile_client/model/service/abstract_auth_service.dart';
import 'package:restobook_mobile_client/model/service/mock_auth_service.dart';
import 'package:restobook_mobile_client/view/login_screen/login_screen.dart';
import 'package:restobook_mobile_client/view/main_screen/main_screen.dart';
import 'package:restobook_mobile_client/view/onboarding/onboarding_screen.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

void main() {
  AppMetrica.runZoneGuarded(() {
    AppMetrica.activate(
        const AppMetricaConfig(String.fromEnvironment("AppMetricaKey")));

    GetIt.I.registerSingleton<MockBackend>(MockBackend());
    GetIt.I.registerSingleton<AbstractTableRepository>(MockTablesRepository());
    GetIt.I.registerSingleton<AbstractReservationRepository>(
        MockReservationsRepository());
    GetIt.I.registerSingleton<AbstractEmployeeRepository>(
        MockEmployeeRepository());
    GetIt.I.registerSingleton<AbstractAuthService>(MockAuthService());

    FlutterError.onError = (details) => print(details);

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => EmployeeViewModel()),
      ChangeNotifierProvider(create: (context) => ReservationViewModel()),
      ChangeNotifierProvider(create: (context) => TableViewModel()),
      ChangeNotifierProvider(create: (context) => ApplicationViewModel())
    ], child: const MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<ApplicationViewModel>(context, listen: false)
        .initIsFirstEnter();
  }

  @override
  Widget build(BuildContext context) {
    Widget home = context.read<ApplicationViewModel>().firstEnter
        ? const OnboardingScreen()
        : context.read<ApplicationViewModel>().authorized
            ? const MainScreen()
            : const LoginScreen();
    context.read<ApplicationViewModel>().enter();
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('ru')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x008b5350)),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
