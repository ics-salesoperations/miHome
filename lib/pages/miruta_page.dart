import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:reactive_forms/reactive_forms.dart';
/*
Future<void> doTask() async {
  LocationBloc info = LocationBloc();

  //EN INICIALIZACION de NetworkInfoBloc SE LLAMA A ACTUALIZAR / ENVIAR DATOS
  await info.actualizarDatosTracking(esBackground: true);
  await info.enviarDatosTracking();
}

void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await doTask();
    return Future.value(true);
  });
}*/

class MiRutaPage extends StatefulWidget {
  @override
  State<MiRutaPage> createState() => _MiRutaPageState();
}

class _MiRutaPageState extends State<MiRutaPage> {
  late LocationBloc locBloc;
  late MapBloc mapBloc;

  final formulario = FormGroup({
    'rango': FormControl<DateTimeRange>(
        validators: [Validators.required],
        value: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now(),
        )),
  });

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    locBloc = BlocProvider.of<LocationBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
    //locBloc.initBackgroundTracking(esBackground: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            25,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(253, 253, 252, 251),
            blurRadius: 1,
            offset: Offset(1, 1),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/lottie/construction.json',
            height: 100,
          ),
          const Center(
            child: Text(
              "Disculpas...",
              style: TextStyle(
                fontFamily: 'CronosLPro',
                fontSize: 36,
                color: kSecondaryColor,
              ),
            ),
          ),
          const Center(
            child: Text(
              "Módulo en construcción",
              style: TextStyle(
                fontFamily: 'CronosLPro',
                fontSize: 16,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ), /*Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Mi Ruta",
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'CronosSPro',
                color: kSecondaryColor,
              ),
            ),
            Container(
              //height: size.height * 0.2,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(248, 245, 246, 245),
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          if (state.followingUser) {
                            locBloc.stopFollowingUser();
                            //await Workmanager().cancelAll();
                          } else {
                            await locBloc.startFollowingUser();

                            /*
                            await Workmanager().initialize(
                              callBackDispatcher,
                            );
                            await Workmanager().registerPeriodicTask(
                              'mydefault_1',
                              'Location Tracking',
                              frequency: const Duration(minutes: 15),
                            );*/
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: size.width * 0.4,
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                25,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                              const VerticalDivider(),
                              Text(
                                state.followingUser ? "Detener" : "Iniciar",
                                style: const TextStyle(
                                  fontFamily: 'CronosLPro',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      state.followingUser
                          ? Text(
                              "Iniciado desde " +
                                  DateFormat('dd/MM/yyyy HH:mm:ss')
                                      .format(state.trackingStart!),
                              style: const TextStyle(
                                fontFamily: 'CronosLPro',
                                color: kPrimaryColor,
                                fontSize: 16,
                              ),
                            )
                          : Container()
                    ],
                  );
                },
              ),
            ),
            const Divider(),
            Container(
              //height: size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(248, 245, 246, 245),
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Mis Rutas",
                      style: TextStyle(
                        fontFamily: 'CronosSPro',
                        fontSize: 18,
                        color: kSecondaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  ReactiveFormBuilder(
                    form: () => formulario,
                    builder: (context, form, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "     Filtrar:",
                            style: TextStyle(
                              fontFamily: 'CronosLPro',
                              fontSize: 20,
                              color: kSecondaryColor,
                            ),
                          ),
                          ReactiveDateRangePicker(
                            formControlName: 'rango',
                            lastDate: DateTime.now(),
                            errorFormatText: "Formato de fecha inválido.",
                            validationMessages: {
                              "required": ((error) =>
                                  "Rango de fechas inválido")
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              helperText: '',
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            height: 30,
                            child: ReactiveFormConsumer(
                              builder: (context, frm, child) => MaterialButton(
                                child: Container(
                                  height: 30,
                                  width: 115,
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(22),
                                    ),
                                    color: kPrimaryColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/Iconos/filter.svg',
                                        height: 16,
                                      ),
                                      const Flexible(
                                        child: Center(
                                          child: Text(
                                            "Filtrar",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'CronosLPro',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  if (frm.valid) {
                                    DateTimeRange rango = frm.controls['rango']!
                                        .value as DateTimeRange;

                                    await locBloc.actualizarReporteTracking(
                                      start: DateTime(
                                        rango.start.year,
                                        rango.start.month,
                                        rango.start.day,
                                      ),
                                      end: DateTime(
                                        rango.end.year,
                                        rango.end.month,
                                        rango.end.day,
                                        24,
                                        59,
                                        59,
                                      ),
                                    );

                                    mapBloc.add(
                                      onUpdateUserPolylinesEvent(),
                                    );
                                  } else {
                                    print("FORMULARIO INVALIDO");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {
                return MapView(
                  initialLocation: locBloc.state.lastKnownLocation ??
                      const LatLng(14.078750526315387, -87.1971045243957),
                  polylines: mapState.polylines.values.toSet(),
                  markers: mapState.markers.values.toSet(),
                );
              },
            ),
          ],
        ),
      ),
    */
    );
  }
}
