import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/pages/detalle_geo_page.dart';
import 'package:mihome_app/screens/screens.dart';

import '../helpers/helpers.dart';

class GeorreferenciarPage extends StatefulWidget {
  const GeorreferenciarPage({Key? key}) : super(key: key);

  @override
  _GeorreferenciarPageState createState() => _GeorreferenciarPageState();
}

class _GeorreferenciarPageState extends State<GeorreferenciarPage> {
  late Animation<double> girar;

  late GeoSearchBloc _geoBloc;
  late MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();

    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    _mapBloc = BlocProvider.of<MapBloc>(context);
    //_mapBloc.drawGeoMarkers(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 252),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(245, 245, 245, 252),
        elevation: 0,
        title: NeumorphicText(
          "Georreferenciar",
          style: const NeumorphicStyle(
            color: kPrimaryColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 20,
            fontFamily: 'CronosSPro',
          ),
        ),
        leading: Center(
          child: NeumorphicButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.all(12),
            style: const NeumorphicStyle(
              depth: 8,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            child: NeumorphicIcon(
              Icons.arrow_back_outlined,
              size: 22,
              style: const NeumorphicStyle(
                color: kSecondaryColor,
              ),
            ),
          ),
        ),
        actions: [
          Center(
            child: NeumorphicButton(
              padding: const EdgeInsets.all(12),
              style: const NeumorphicStyle(
                depth: 8,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: NeumorphicIcon(
                Icons.search,
                size: 22,
                style: const NeumorphicStyle(
                  color: kSecondaryColor,
                ),
              ),
              onPressed: () async {
                final resultado = await showSearch(
                  context: context,
                  delegate: GeoSearch(),
                );

                if (resultado != null &&
                    resultado.latitud != 0 &&
                    resultado.latitud != null) {
                  await _mapBloc.drawSelectedMarket(
                    context: context,
                    datos: resultado,
                  );
                  _mapBloc.moveCamera(
                    LatLng(
                      resultado.latitud ?? 0,
                      resultado.longitud ?? 0,
                    ),
                  );
                } else if (resultado != null) {
                  _geoBloc.add(
                    OnNewPlacesFoundEvent(
                      geo: [resultado],
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetalleGeoPage(),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
      body: const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: MapScreen(),
      ),
    );
  }
}
