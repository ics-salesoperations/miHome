import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/blocs/blocs.dart';

import '../app_styles.dart';
import '../models/models.dart';

class ProcessingGeo extends StatefulWidget {
  final GeorreferenciaLog geoLog;
  final Georreferencia geo;

  const ProcessingGeo({
    Key? key,
    required this.geoLog,
    required this.geo,
  }) : super(key: key);

  @override
  State<ProcessingGeo> createState() => _ProcessingGeoState();
}

class _ProcessingGeoState extends State<ProcessingGeo> {
  late GeoSearchBloc _geoBloc;

  @override
  void initState() {
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);

    _geoBloc.procesarInfoGeo(
      actualizacion: widget.geo,
      detalleLog: widget.geoLog,
    );


    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.9,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      child: BlocBuilder<GeoSearchBloc, GeoSearchState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/processing.json',
                width: 200,
                height: 250,
                animate: true,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 200,
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffcccaaa),
                      blurRadius: 5,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          state.guardandoGeo
                              ? 'assets/Iconos/warning.svg'
                              : 'assets/Iconos/done.svg',
                          height: 20,
                        ),
                        const Text(
                          " Guardado localmente: ",
                          style: TextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                        Text(
                          !state.guardandoGeo ? "Exitoso" : "En proceso...",
                          style: const TextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          !state.enviandogeo
                              ? 'assets/Iconos/done.svg'
                              : 'assets/Iconos/warning.svg',
                          height: 20,
                        ),
                        const Text(
                          " Enviado: ",
                          style: TextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                        Text(
                          (!state.enviandogeo && !state.guardandoGeo)
                              ? "Exitoso"
                              : "En Proceso...",
                          style: const TextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Observación: ",
                          style: TextStyle(
                            fontFamily: 'CronosSPro',
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            state.guardandoGeo
                                ? "Guardando datos..."
                                : state.enviandogeo
                                    ? "Datos guardados exitosamente. Sincronizando datos."
                                    : "Información procesada exitosamente",
                            style: const TextStyle(
                                fontFamily: 'CronosLPro',
                                fontSize: 16,
                                color: kSecondaryColor,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                elevation: 4,
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cerrar",
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontFamily: 'CronosLPro',
                    fontSize: 16,
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
