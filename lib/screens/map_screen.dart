import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/views/views.dart';
import 'package:mihome_app/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  //late MapBloc mapBloc;

  @override
  void initState() {
    locationBloc = BlocProvider.of<LocationBloc>(context);
    //mapBloc = BlocProvider.of<MapBloc>(context);
    locationBloc.startFollowingUser();
    super.initState();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
        if (locationState.lastKnownLocation == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Text("Espere por Favor...")
              ],
            ),
          );
        }

        return BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            Map<String, Polyline> polylines = Map.from(mapState.polylines);
            Map<String, Marker> markers = {};

            markers.addAll(Map.from(mapState.markerSelect));

            if (mapState.showMarkers) {
              markers.addAll(Map.from(mapState.markers));
            }

            if (mapState.showNodos) {
              markers.addAll(Map.from(mapState.markersNodos));
            }

            if (mapState.showAmps) {
              markers.addAll(Map.from(mapState.markersAmps));
            }

            if (mapState.showTaps) {
              markers.addAll(Map.from(mapState.markersTaps));
            }

            if (mapState.showClientes) {
              markers.addAll(Map.from(mapState.markersClientes));
            }

            if (!mapState.showMyRoute) {
              polylines.removeWhere((key, value) => key == 'myRoute');
            }

            if (!mapState.showMarkers &&
                !mapState.showNodos &&
                !mapState.showAmps &&
                !mapState.showTaps &&
                !mapState.showClientes) {
              markers.removeWhere(
                  (key, value) => (key != 'start') && (key != 'end'));
            }
            return MapView(
              initialLocation: locationState.lastKnownLocation!,
              polylines: polylines.values.toSet(),
              markers: markers.values.toSet(),
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          //BtnShowTaps(),
          //SizedBox(
          //  height: 10,
          //),
          //BtnShowNodos(),
          //BtnFollowUser(),
          BtnCurrentLocation(),
        ],
      ),
    );
  }
}
