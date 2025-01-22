import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ConsultaEquipoPage extends StatefulWidget {
  const ConsultaEquipoPage({Key? key}) : super(key: key);

  @override
  _ConsultaEquipoPageState createState() => _ConsultaEquipoPageState();
}

class _ConsultaEquipoPageState extends State<ConsultaEquipoPage>
    with TickerProviderStateMixin {
  late ActualizarBloc _actualizarBloc;

  final form = FormGroup({
    'serie': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
  });

  @override
  void initState() {
    super.initState();

    _actualizarBloc = BlocProvider.of<ActualizarBloc>(context);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(ctx).padding.top + 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: kFourColor,
                ),
              ),
            ),
            Center(
              child: Text(
                "Consultar Equipo",
                style: TextStyle(
                  color: kSecondaryColor.withOpacity(0.6),
                  fontFamily: 'CronosSPro',
                  fontSize: 28,
                ),
              ),
            ),
            NeumorphicIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 70,
              style: const NeumorphicStyle(
                shape: NeumorphicShape.concave,
                depth: 12,
                lightSource: LightSource.topLeft,
                intensity: 1,
                surfaceIntensity: 1,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: BlocBuilder<ActualizarBloc, ActualizarState>(
                    builder: (context, state) {
                      if (state.mensaje.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SOHorizontalCard(
                                title: "¡Actualizando!",
                                content: state.mensaje.toString(),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                        });
                      }

                      return Column(
                        children: [
                          Neumorphic(
                            padding: const EdgeInsets.all(15),
                            style: const NeumorphicStyle(
                              depth: 2,
                              color: Colors.transparent,
                            ),
                            child: ReactiveForm(
                              formGroup: form,
                              child: Column(
                                children: [
                                  const SOScannerFieldCustom(
                                    campo: 'serie',
                                    label: 'Serie del equipo',
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  state.consultandoEquipo
                                      ? const CircularProgressIndicator()
                                      : ReactiveFormConsumer(
                                          key: const Key('consultar'),
                                          builder: (context, form, _) =>
                                              NeumorphicButton(
                                            padding: const EdgeInsets.all(12),
                                            style: const NeumorphicStyle(
                                              color: Colors.transparent,
                                            ),
                                            onPressed: !form.valid
                                                ? null
                                                : () {
                                                    _actualizarBloc.consultarEquipo(
                                                        serie: form
                                                            .control('serie')
                                                            .value
                                                            .toString()
                                                            .toUpperCase() //'KAON0C012607',
                                                        );
                                                  },
                                            child: Center(
                                              child: NeumorphicText(
                                                'Consultar',
                                                style: const NeumorphicStyle(
                                                  color: kSecondaryColor,
                                                ),
                                                textStyle: NeumorphicTextStyle(
                                                  fontFamily: 'CronosLPro',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          (state.equipos.isEmpty || state.consultandoEquipo)
                              ? Container()
                              : Neumorphic(
                                  style: const NeumorphicStyle(
                                    color: Colors.transparent,
                                    depth: -2,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: SizedBox(
                                    height: 200,
                                    child: state.equipos[0].data.isEmpty
                                        ? NeumorphicText(
                                            'No se ha encontrado ningún equipo',
                                            style: const NeumorphicStyle(
                                              color: kSecondaryColor,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontFamily: 'CronosLPro',
                                              fontSize: 14,
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              NeumorphicText(
                                                'Detalle del Equipo',
                                                style: const NeumorphicStyle(
                                                  color: kPrimaryColor,
                                                ),
                                                textStyle: NeumorphicTextStyle(
                                                  fontFamily: 'CronosSPro',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const Divider(),
                                              DetalleEquipoItem(
                                                label: 'SERIE: ',
                                                valor: state.equipos[0].data[0]
                                                    .publicIdentifier
                                                    .toString(),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              DetalleEquipoItem(
                                                label: 'Nombre: ',
                                                valor: state
                                                    .equipos[0].data[0].name,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              DetalleEquipoItem(
                                                label: 'Descripción: ',
                                                valor: state.equipos[0].data[0]
                                                    .description,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              DetalleEquipoItem(
                                                label: 'Tipo: ',
                                                valor: state
                                                    .equipos[0].data[0].type,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              DetalleEquipoItem(
                                                label: 'Tipo Base: ',
                                                valor: state.equipos[0].data[0]
                                                    .baseType,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              DetalleEquipoItem(
                                                label: 'Estado: ',
                                                valor: state.equipos[0].data[0]
                                                    .lifecycleState,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              //Text(equipo.connectionInterfaceCli),
                                            ],
                                          ),
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class DetalleEquipoItem extends StatelessWidget {
  final String label;
  final String valor;
  const DetalleEquipoItem({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        NeumorphicText(
          label,
          style: const NeumorphicStyle(
            color: kSecondaryColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontFamily: 'CronosLPro',
            fontSize: 14,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        NeumorphicText(
          valor,
          style: const NeumorphicStyle(
            color: kSecondaryColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontFamily: 'CronosLPro',
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
