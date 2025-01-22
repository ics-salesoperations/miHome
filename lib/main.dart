import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/routes/routes.dart';

bool? seenOnboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => LocationBloc(),
        ),
        BlocProvider(
          create: (context) => FilterBloc(),
        ),
        BlocProvider(
          create: (context) => PermissionBloc(),
        ),
        BlocProvider(
          create: (context) => SyncBloc(),
        ),
        BlocProvider(
          create: (context) => SophiaBloc(),
        ),
        BlocProvider(
          create: (context) => ActualizarBloc(),
        ),
        BlocProvider(
          create: (context) => AgendaBloc(),
        ),
        BlocProvider(
          create: (context) => VisitaBloc(),
        ),
        BlocProvider(
          create: (context) => FormularioBloc(),
        ),
        BlocProvider(
          create: (context) => CarritoBloc(),
        ),
        BlocProvider(
          create: (context) => NetworkInfoBloc(),
        ),
        BlocProvider(
          create: (context) => SpeedTestBloc(),
        ),
        BlocProvider(
          create: (context) => GeoSearchBloc(),
        ),
        BlocProvider(
          create: (context) => OTStepBloc(),
        ),
        BlocProvider(
          create: (context) => MapBloc(
            locationBloc: BlocProvider.of<LocationBloc>(context),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

//prueba
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      title: 'Mi Home',
      initialRoute: 'inicial',
      routes: appRoutes,
      themeMode: ThemeMode.light,
      theme: const NeumorphicThemeData(
        baseColor: Color.fromARGB(
          245,
          245,
          245,
          245,
        ),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
    );
  }
}
