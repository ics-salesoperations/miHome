import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:reactive_date_range_picker/reactive_date_range_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/models.dart';
import '../screens/screens.dart';
//import 'package:elegant_notification/elegant_notification.dart';

class SincronizarPage extends StatefulWidget {
  const SincronizarPage({Key? key}) : super(key: key);
  @override
  _SincronizarPageState createState() => _SincronizarPageState();
}

class _SincronizarPageState extends State<SincronizarPage> {
  late SyncBloc syncBloc;
  late GeoSearchBloc _geoBloc;

  DBService db = DBService();
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
    super.initState();
    initializeDateFormatting('es_Es', null);
    syncBloc = BlocProvider.of<SyncBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    syncBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NeumorphicAppBar(
          color: Colors.transparent,
          centerTitle: true,
          title: NeumorphicText(
            "Mi Gestión",
            style: const NeumorphicStyle(
              color: kSecondaryColor,
              depth: 0,
            ),
            textStyle: NeumorphicTextStyle(
              fontFamily: 'CronosSPro',
              fontSize: 26,
            ),
          ),
          leading: NeumorphicButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.all(12),
            style: const NeumorphicStyle(
              depth: 0,
              color: Colors.transparent,
            ),
            child: NeumorphicIcon(
              Icons.arrow_back,
              size: 26,
              style: const NeumorphicStyle(
                color: kPrimaryColor,
                depth: 0,
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: BlocBuilder<SyncBloc, SyncState>(builder: (context, state) {
              if (state.actualizandoResumen) {
                return const Center(child: CircularProgressIndicator());
              }

              final datos = state.resSincronizar;
              final sincronizados = datos
                  .where(
                    (resp) => resp.porcentajeSync == 100,
                  )
                  .length;

              final noSincronizados = datos.length - sincronizados;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _Filtros(
                    formulario: formulario,
                    syncBloc: syncBloc,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _Resultados(
                    sincronizados: sincronizados,
                    noSincronizados: noSincronizados,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _Botones(
                    syncBloc: syncBloc,
                    geoBloc: _geoBloc,
                  ),
                  const Divider(),
                  const Text(
                    "Lista de gestiones",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: 'CronosSPro',
                      fontSize: 18,
                    ),
                  ),
                  state.mensaje == ""
                      ? Container()
                      : Container(
                          height: 60,
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Lottie.asset(
                                'assets/lottie/cargando.json',
                                height: 40,
                              ),
                              Text(
                                " " + state.mensaje,
                                style: const TextStyle(
                                  fontFamily: 'CronosLPro',
                                  fontSize: 14,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: datos.length,
                        separatorBuilder: (context, index) => Container(
                          height: 5,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              GeorreferenciaLog geoData = GeorreferenciaLog();

                              final geoLogId = await db.getGeoLogByCodigo(
                                codigo: datos[index].codigo!,
                              );

                              if (datos[index].categoria.toString() ==
                                      'GEORREFERENCIACION' &&
                                  datos[index]
                                      .tipo
                                      .toString()
                                      .contains("COORDENADAS")) {
                                geoData = geoLogId.first;
                              }
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return (datos[index].categoria.toString() ==
                                              'GEORREFERENCIACION' &&
                                          datos[index]
                                              .tipo
                                              .toString()
                                              .contains("COORDENADAS"))
                                      ? DetalleGeoScreen(
                                          geo: geoData,
                                          idVisita:
                                              datos[index].idVisita.toString(),
                                          fechaVisita: datos[index].fecha!,
                                          tipo: datos[index].tipo.toString(),
                                        )
                                      : (datos[index].categoria.toString() ==
                                                      'GEORREFERENCIACION' &&
                                                  !datos[index]
                                                      .tipo
                                                      .toString()
                                                      .contains(
                                                          "COORDENADAS")) ||
                                              datos[index]
                                                      .categoria
                                                      .toString() ==
                                                  'AUDITORIA'
                                          ? DetalleFormScreen(
                                              datos: datos[index],
                                            )
                                          : Container();
                                },
                              );
                            },
                            child: FadeInLeft(
                              child: SOFormCard(
                                res: datos[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ));
  }
}

class _Botones extends StatelessWidget {
  const _Botones({
    Key? key,
    required this.syncBloc,
    required this.geoBloc,
  }) : super(key: key);

  final SyncBloc syncBloc;
  final GeoSearchBloc geoBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              depth: 12,
              shadowDarkColor: kSecondaryColor.withOpacity(0.7),
              shadowLightColor: Colors.white54,
            ),
            padding: const EdgeInsets.all(0),
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/delete.json',
                    height: 22,
                  ),
                  Center(
                    child: NeumorphicText(
                      " Eliminar sincronizados",
                      style: const NeumorphicStyle(
                        color: Colors.white,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 14,
                        fontFamily: 'CronosLPro',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              //syncBloc.
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const ConfirmationScreen(
                  mensaje:
                      "¿Estas seguro de eliminar los formularios ya sincronizados?",
                ),
              ).then((value) async {
                if (value) {
                  await syncBloc.eliminarDatosLocalesSincronizados();
                  syncBloc.init();
                }
              });
            },
          ),
          NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              depth: 12,
              shadowDarkColor: kSecondaryColor.withOpacity(0.7),
              shadowLightColor: Colors.white54,
            ),
            padding: const EdgeInsets.all(0),
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lottie.asset(
                    'assets/lottie/send.json',
                    height: 22,
                  ),
                  NeumorphicText(
                    " Sincronizar",
                    style: const NeumorphicStyle(
                      color: Colors.white,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 14,
                      fontFamily: 'CronosLPro',
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () async {
              await syncBloc.sincronizarDatos();
              await geoBloc.sincronizarDatos();
              await syncBloc.init();
            },
          ),
        ],
      ),
    );
  }
}

class _Resultados extends StatelessWidget {
  const _Resultados({
    Key? key,
    required this.sincronizados,
    required this.noSincronizados,
  }) : super(key: key);

  final int sincronizados;
  final int noSincronizados;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: const EdgeInsets.all(12),
      style: const NeumorphicStyle(
        color: Colors.transparent,
        depth: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              NeumorphicText(
                "$sincronizados",
                style: const NeumorphicStyle(
                  color: kSecondaryColor,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosSPro',
                  fontSize: 45,
                ),
              ),
              NeumorphicText(
                "Sincronizados",
                style: NeumorphicStyle(
                  color: kSecondaryColor.withOpacity(0.75),
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosSPro',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Lottie.asset(
            'assets/lottie/check_list.json',
            height: 50,
          ),
          Column(
            children: [
              NeumorphicText(
                "$noSincronizados",
                style: const NeumorphicStyle(
                  color: kSecondaryColor,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosSPro',
                  fontSize: 45,
                ),
              ),
              NeumorphicText(
                "Sin sincronizar",
                style: NeumorphicStyle(
                  color: kSecondaryColor.withOpacity(0.75),
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosSPro',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Filtros extends StatelessWidget {
  const _Filtros({
    Key? key,
    required this.formulario,
    required this.syncBloc,
  }) : super(key: key);

  final FormGroup formulario;
  final SyncBloc syncBloc;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        depth: 12,
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.all(12),
      child: ReactiveFormBuilder(
        form: () => formulario,
        builder: (context, form, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeumorphicText(
                "   Filtrar:",
                style: const NeumorphicStyle(
                  color: kSecondaryColor,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 20,
                ),
              ),
              ReactiveDateRangePicker(
                formControlName: 'rango',
                lastDate: DateTime.now(),
                locale: const Locale('es', 'ES'),
                errorFormatText: "Formato de fecha inválido.",
                validationMessages: {
                  "required": ((error) => "Rango de fechas inválido")
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
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
                  builder: (context, frm, child) => NeumorphicButton(
                    padding: const EdgeInsets.all(6),
                    style: const NeumorphicStyle(
                      color: kPrimaryColor,
                      depth: 10,
                      shape: NeumorphicShape.convex,
                    ),
                    onPressed: () {
                      if (frm.valid) {
                        DateTimeRange rango =
                            frm.controls['rango']!.value as DateTimeRange;

                        syncBloc.getRespResumen(
                          rango.start,
                          rango.end,
                        );
                      } else {}
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/Iconos/filter.svg',
                          height: 16,
                        ),
                        Flexible(
                          child: Center(
                            child: NeumorphicText(
                              "Filtrar",
                              style: const NeumorphicStyle(
                                color: Colors.white,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 18,
                                fontFamily: 'CronosLPro',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
