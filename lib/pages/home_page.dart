import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/pages/pages.dart';
import 'package:mihome_app/pages/tracking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late NavigationBloc navBloc;
  late AuthBloc authBloc;
  late AnimationController animationController;
  late TabController ctrlTab;
  int _groupValue = 1;

  @override
  void initState() {
    super.initState();
    navBloc = BlocProvider.of<NavigationBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    ctrlTab = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    ctrlTab.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        245,
        245,
        245,
        252,
      ),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return state.selectedPage;
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Neumorphic(
          padding: const EdgeInsets.all(8),
          style: const NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: 12,
            lightSource: LightSource.bottom,
            intensity: 0.7,
            color: kPrimaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NeumorphicRadio(
                value: 0,
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value as int;
                    navBloc.add(
                      OnChangePageEvent(
                        selectedPage: TrackingPage(
                          controlador: animationController,
                        ),
                      ),
                    );
                  });
                },
                style: NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      90,
                    ),
                  ),
                  lightSource: LightSource.topLeft,
                  intensity: 1,
                  unselectedColor: kPrimaryColor,
                  unselectedDepth: 25,
                  selectedColor: kPrimaryColor,
                  selectedDepth: -25,
                ),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: NeumorphicIcon(
                      FontAwesomeIcons.towerCell,
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        color: _groupValue != 0 ? kFourColor : kSecondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              NeumorphicRadio(
                value: 1,
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value as int;
                    navBloc.add(
                      const OnChangePageEvent(
                        selectedPage: InicioPage(),
                      ),
                    );
                  });
                },
                style: NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      90,
                    ),
                  ),
                  lightSource: LightSource.topLeft,
                  intensity: 1,
                  unselectedColor: kPrimaryColor,
                  unselectedDepth: 25,
                  selectedColor: kPrimaryColor,
                  selectedDepth: -25,
                ),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: NeumorphicIcon(
                      FontAwesomeIcons.house,
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        color: _groupValue != 1 ? kFourColor : kSecondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              NeumorphicRadio(
                value: 2,
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value as int;
                    navBloc.add(
                      OnChangePageEvent(
                        selectedPage: MapPage(),
                      ),
                    );
                  });
                },
                style: NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      90,
                    ),
                  ),
                  lightSource: LightSource.topLeft,
                  intensity: 1,
                  unselectedColor: kPrimaryColor,
                  unselectedDepth: 25,
                  selectedColor: kPrimaryColor,
                  selectedDepth: -25,
                ),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: NeumorphicIcon(
                      FontAwesomeIcons.mapLocationDot,
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        color: _groupValue != 2 ? kFourColor : kSecondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
