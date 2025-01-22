import 'dart:isolate';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/pages/reporte_senal_page.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:workmanager/workmanager.dart';

Future<void> doTask() async {
  NetworkInfoBloc info = NetworkInfoBloc();

  //EN INICIALIZACION de NetworkInfoBloc SE LLAMA A ACTUALIZAR / ENVIAR DATOS
  await info.actualizarDatos(esBackground: true);
  await info.enviarDatos();
}

void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await doTask();
    return Future.value(true);
  });
}

/*inicio nuevo*/

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    await doTask();
    FlutterForegroundTask.updateService(
      notificationTitle: 'Tracking de Señal',
      notificationText:
          'Cantidad: $_eventCount, última: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
    );

    // Send data to the main isolate.
    sendPort?.send(_eventCount);

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

/*fin nuevo */

class TrackingPage extends StatefulWidget {
  final AnimationController controlador;

  const TrackingPage({Key? key, required this.controlador}) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with TickerProviderStateMixin {
  ReceivePort? _receivePort;

  /*NUEVO CODIGO*/

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'notification_channel_id',
          channelName: 'Foreground Notification',
          channelDescription:
              'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.HIGH,
          priority: NotificationPriority.HIGH,
          iconData: const NotificationIconData(
            resType: ResourceType.mipmap,
            resPrefix: ResourcePrefix.ic,
            name: 'launcher',
            backgroundColor: kSecondaryColor,
          ),
          buttons: [
            const NotificationButton(id: 'sendButton', text: 'Send'),
            const NotificationButton(id: 'testButton', text: 'Test'),
          ],
          enableVibration: true),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        interval: const Duration(seconds: 30).inMilliseconds,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hola');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Servicio en segundo plano corriendo.',
        notificationText: 'Toca para regresar al app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message is int) {
        print('eventCount: $message');
      } else if (message is String) {
        if (message == 'onNotificationPressed') {
          Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (message is DateTime) {
        print('timestamp: ${message.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  T? _ambiguate<T>(T? value) => value;

  Animation<double>? topBarAnimation;
  late Animation<double> agrandar;
  late AnimationController btnController;
  late AnimationController heartController;
  late Animation<double> opacidad;
  late Animation<double> heart;

  List<Widget> listWidgets = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  late NetworkInfoBloc networkInfoBloc;
  late NavigationBloc navBloc;

  final DBService _db = DBService();

  @override
  void initState() {
    super.initState();
    networkInfoBloc = BlocProvider.of<NetworkInfoBloc>(context);
    navBloc = BlocProvider.of<NavigationBloc>(context);
    networkInfoBloc.init(
      esBackground: false,
    );

    _db.getInformacionDia();

    btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controlador,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    agrandar = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: btnController,
        curve: Curves.easeOut,
      ),
    );

    heart = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: heartController,
        curve: Curves.easeOut,
      ),
    );

    opacidad = Tween(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: btnController,
        curve: const Interval(0, 1, curve: Curves.easeOut),
      ),
    );

    //Agregamos un listener
    btnController.addListener(() {
      if (btnController.status == AnimationStatus.completed) {
        btnController.reverse();
      } else if (btnController.status == AnimationStatus.dismissed) {
        btnController.forward();
      }
    });

    //Agregamos un listener
    heartController.addListener(() {
      if (heartController.status == AnimationStatus.completed) {
        heartController.repeat();
      }
    });

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    _initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
  }

  @override
  void dispose() {
    btnController.dispose();
    heartController.dispose();
    _closeReceivePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //iniciamos la animación

    return WithForegroundTask(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getAppBarTracking(),
            Expanded(
              child: getListofWidgets(),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  Widget getListofWidgets() {
    return BlocBuilder<NetworkInfoBloc, NetworkInfoState>(
      builder: (context, state) {
        if (!state.actualizado) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //NetworkInfo info = state.info!;

        return ListView.builder(
          controller: scrollController,
          itemCount: 4,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            widget.controlador.forward();
            switch (index) {
              case 0:
                return Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: const Text(
                    "Lectura Automática",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'CronosSPro',
                      fontSize: 18,
                    ),
                  ),
                );
              case 1:
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildCircularContainer(
                      radius: 200,
                    ),
                    _buildCircularContainer(
                      radius: 250,
                    ),
                    _buildCircularContainer(
                      radius: 300,
                    ),
                    Align(
                      child: Center(
                        child: BlocBuilder<NetworkInfoBloc, NetworkInfoState>(
                          builder: (context, state) {
                            btnController.forward();
                            heartController.forward();
                            return NeumorphicButton(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(
                                    190,
                                  ),
                                ),
                                depth: 10,
                                lightSource: LightSource.topLeft,
                                intensity: 0.8,
                                surfaceIntensity: 1,
                                color: Colors.white12,
                              ),
                              child: state.activado
                                  ? _BotonTracking(
                                      label: "Detener",
                                    )
                                  : _BotonTracking(
                                      label: "Iniciar",
                                    ),
                              onPressed: () async {
                                if (state.activado) {
                                  await Workmanager()
                                      .cancelByTag('signal_tracker_mihome');
                                } else {
                                  await Workmanager().initialize(
                                    callBackDispatcher,
                                    //isInDebugMode: true,
                                  );
                                  await Workmanager().registerPeriodicTask(
                                    '4001',
                                    'signal_tracker_mihome',
                                    tag: 'signal_tracker_mihome',
                                    frequency: const Duration(minutes: 15),
                                  );
                                }
                                networkInfoBloc.toogleActivado();
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              case 2:
                return Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: const Text(
                    "Mi Gestión",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'CronosSPro',
                      fontSize: 18,
                    ),
                  ),
                );
              case 3:
                return SizedBox(
                  height: 245,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(15),
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            navBloc.crearRuta(
                              destination: ReporteSenalPage(
                                animationController: widget.controlador,
                              ),
                            ),
                          );
                        },
                        child: SOBlueIconCard(
                          title: "Hoy",
                          icon: FontAwesomeIcons.calendarDay,
                          content:
                              BlocBuilder<NetworkInfoBloc, NetworkInfoState>(
                            builder: (context, state) {
                              if (state.guardando) {
                                return const CircularProgressIndicator();
                              }
                              return FutureBuilder<List<int>>(
                                future: _db.getInformacionDia(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final informacion = snapshot.data!;

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        child: SOIconLabel(
                                          label: "${informacion[1]} manuales",
                                          asset: 'assets/Iconos/phone.svg',
                                          size: const Size(18, 18),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      SizedBox(
                                        height: 22,
                                        child: SOIconLabel(
                                          label:
                                              "${informacion[0]} automáticas",
                                          asset: 'assets/Iconos/trophy.svg',
                                          size: const Size(18, 18),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            BounceInDown(
                                              child: Text(
                                                "${informacion[0] + informacion[1]}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: kThirdColor,
                                                  fontFamily: 'CronosSPro',
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              " lecturas",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kThirdColor,
                                                fontFamily: 'CronosLPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SOBlueIconCard(
                        title: 'Este mes',
                        icon: FontAwesomeIcons.solidCalendar,
                        content: BlocBuilder<NetworkInfoBloc, NetworkInfoState>(
                          builder: (context, state) {
                            if (state.guardando) {
                              return const CircularProgressIndicator();
                            }
                            return FutureBuilder<List<int>>(
                                future: _db.getInformacionMes(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final informacion = snapshot.data!;
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        child: SOIconLabel(
                                          label: "${informacion[1]} manuales",
                                          asset: 'assets/Iconos/phone.svg',
                                          size: const Size(18, 18),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      SizedBox(
                                        height: 22,
                                        child: SOIconLabel(
                                          label:
                                              "${informacion[0]} automáticas",
                                          asset: 'assets/Iconos/trophy.svg',
                                          size: const Size(18, 18),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                          top: 30,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${informacion[0] + informacion[1]}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: kThirdColor,
                                                fontFamily: 'CronosLPro',
                                                fontSize: 24,
                                              ),
                                            ),
                                            const Text(
                                              " lecturas",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kThirdColor,
                                                fontFamily: 'CronosLPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SOBlueIconCard(
                        title: 'Sin sincronizar',
                        icon: FontAwesomeIcons.signal,
                        content: BlocBuilder<NetworkInfoBloc, NetworkInfoState>(
                          builder: (context, state) {
                            if (state.guardando) {
                              return const CircularProgressIndicator();
                            }
                            return FutureBuilder<List<int>>(
                                future: _db.getInformacionSinSincronizar(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final informacion = snapshot.data!;
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        child: SOIconLabel(
                                          label: "${informacion[1]} manuales",
                                          asset: 'assets/Iconos/phone.svg',
                                          size: const Size(18, 18),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      SizedBox(
                                        height: 22,
                                        child: SOIconLabel(
                                          label:
                                              "${informacion[0]} automáticas",
                                          asset: 'assets/Iconos/trophy.svg',
                                          size: const Size(18, 18),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                          top: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${informacion[0] + informacion[1]}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: kThirdColor,
                                                fontFamily: 'CronosLPro',
                                                fontSize: 24,
                                              ),
                                            ),
                                            const Text(
                                              " lecturas",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kThirdColor,
                                                fontFamily: 'CronosLPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                );

              default:
                return const SizedBox(
                  height: 10,
                );
            }
          },
        );
      },
    );
  }

  Widget _buildCircularContainer({
    required double radius,
  }) {
    return AnimatedBuilder(
      animation: agrandar,
      builder: (context, child) {
        Color c = kPrimaryColor.withOpacity(0.1);
        return Container(
          margin: EdgeInsets.only(
            top: (radius - agrandar.value * radius) / 2,
            bottom: (radius - agrandar.value * radius) / 2,
          ),
          width: agrandar.value * radius,
          height: agrandar.value * radius,
          decoration: BoxDecoration(
            color: c.withOpacity(1 - agrandar.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget getAppBarTracking() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.controlador,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: kPrimaryColor //FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: MediaQuery.of(context).padding.top +
                            16 -
                            8.0 * topBarOpacity,
                        bottom: 12 - 8.0 * topBarOpacity),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tracking de Red',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'CronosSPro',
                                fontWeight: FontWeight.w700,
                                fontSize: 22 + 6 - 6 * topBarOpacity,
                                letterSpacing: 1.2,
                                color:
                                    kSecondaryColor, //FitnessAppTheme.darkerText,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.signal_cellular_4_bar_rounded,
                              color: kSecondaryColor, //FitnessAppTheme.grey,
                              size: 22 + 6 - 6 * topBarOpacity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _BotonTracking({required String label}) {
    return AnimatedBuilder(
      animation: heart,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          // decoration: const BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: kSecondaryColor,
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomPaint(
                  painter: HeartBeatPainter(
                      progress: heart.value,
                      color: kPrimaryColor,
                      beat: label == 'Detener')),
              const SizedBox(
                height: 0,
              ),
              Text(
                label,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 32,
                  fontFamily: 'CronosLPro',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
