import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/pages/pages.dart';

import '../blocs/blocs.dart';

class BottomMapModalGeo extends StatefulWidget {
  final Georreferencia detalle;
  final BuildContext ctx;

  const BottomMapModalGeo({Key? key, required this.detalle, required this.ctx})
      : super(key: key);

  @override
  State<BottomMapModalGeo> createState() => _BottomMapModalGeoState();
}

class _BottomMapModalGeoState extends State<BottomMapModalGeo> {
  late MapBloc _mapBloc;
  late GeoSearchBloc _geoBloc;

  @override
  void initState() {
    super.initState();
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        intensity: 0.7,
        depth: 12,
      ),
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NeumorphicText(
                  "Detalle de " + widget.detalle.tipo.toString().toLowerCase(),
                  style: const NeumorphicStyle(
                    color: kPrimaryColor,
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 18,
                    fontFamily: 'CronosSPro',
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                NeumorphicButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: const NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle()),
                  child: NeumorphicIcon(
                    FontAwesomeIcons.xmark,
                    style: NeumorphicStyle(
                      color: kFourColor.withOpacity(0.6),
                      depth: 2,
                    ),
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Neumorphic(
              style: const NeumorphicStyle(
                  lightSource: LightSource.left, depth: 12),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicText(
                        "Tipo:  ",
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosSPro',
                        ),
                      ),
                      NeumorphicText(
                        widget.detalle.tipo.toString(),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicText(
                        "Código:  ",
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosSPro',
                        ),
                      ),
                      NeumorphicText(
                        widget.detalle.codigo.toString(),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicText(
                        "Nombre: ",
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosSPro',
                        ),
                      ),
                      NeumorphicText(
                        widget.detalle.nombre.toString(),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NeumorphicButton(
                    onPressed: () async {
                      //Navigator.pop(widget.ctx);
                      _geoBloc.add(OnNewPlacesFoundEvent(
                        geo: [
                          widget.detalle,
                        ],
                      ));

                      _geoBloc.add(
                        OnChangeNavHist(
                          geo: [
                            widget.detalle,
                          ],
                        ),
                      );

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetalleGeoPage(),
                        ),
                      ).then((value) async {
                        await _mapBloc.drawGeoMarkers(
                          context: widget.ctx,
                          tipo: 'NODO',
                        );
                        Navigator.pop(widget.ctx);
                      });
                    },
                    child: Row(
                      children: [
                        NeumorphicIcon(
                          FontAwesomeIcons.list,
                          style: NeumorphicStyle(
                            color: kFourColor.withOpacity(0.6),
                            depth: 2,
                          ),
                          size: 14,
                        ),
                        NeumorphicText(
                          "  Detalle",
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 16,
                            fontFamily: 'CronosLPro',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      _mapBloc.drawTreePolyline(
                        datos: widget.detalle,
                        context: widget.ctx,
                      );
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        NeumorphicIcon(
                          FontAwesomeIcons.shareNodes,
                          style: NeumorphicStyle(
                            color: kFourColor.withOpacity(0.6),
                            depth: 2,
                          ),
                          size: 14,
                        ),
                        NeumorphicText(
                          "  Dependencias",
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 16,
                            fontFamily: 'CronosLPro',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
