//aqui definimos todas las rutas que tendra nuestra aplicacion
import 'package:flutter/material.dart';
import 'package:mihome_app/pages/pages.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:mihome_app/views/views.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (_) => const OnBoardingPage(),
  'home': (_) => const HomePage(),
  'login': (_) => LoginPage(),
  'perfil': (_) => const MiPerfilPage(),
  'inicial': (_) => const CargaInicialScreen(),
  'permisos': (_) => const PermisosAccessScreen(),
  'actualizar': (_) => const ActualizarPage(),
  'sincronizar': (_) => const SincronizarPage(),
  'planificacion': (_) => const AgendaPage(),
  'georreferenciar': (_) => const GeorreferenciarPage(),
  'busqueda': (_) => const BusquedaPage(),
  'ftth': (_) => const ConsultaEquipoPage(),
  'sophia': (_) => const SophiaPage(),
};
