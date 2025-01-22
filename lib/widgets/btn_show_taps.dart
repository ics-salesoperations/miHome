import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';

class BtnShowTaps extends StatelessWidget {
  const BtnShowTaps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return NeumorphicButton(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: const NeumorphicBoxShape.circle(),
            color: state.showTaps ? kThirdColor : Colors.white70,
            depth: state.showTaps ? -2 : 12,
          ),
          child: NeumorphicIcon(
            Icons.call_split,
            size: 35,
            style: NeumorphicStyle(
              boxShape: const NeumorphicBoxShape.circle(),
              color: state.showTaps ? Colors.white70 : kThirdColor,
              depth: state.showTaps ? 0 : 6,
            ),
          ),
          onPressed: () async {
            await mapBloc.drawGeoMarkers(
              context: context,
              tipo: 'TAP',
            );
            mapBloc.add(
              const OnToggleShowMarkers(
                tipo: 'TAP',
              ),
            );
          },
        );
      },
    );
  }
}
