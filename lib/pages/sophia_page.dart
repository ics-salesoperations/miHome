import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/screens/sophia_consulta_ot_screen.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SophiaPage extends StatefulWidget {
  const SophiaPage({Key? key}) : super(key: key);

  @override
  _SophiaPageState createState() => _SophiaPageState();
}

class _SophiaPageState extends State<SophiaPage> with TickerProviderStateMixin {
  late SophiaBloc _actualizarBloc;

  final form = FormGroup({
    'serie': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
  });

  @override
  void initState() {
    super.initState();

    _actualizarBloc = BlocProvider.of<SophiaBloc>(context);
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
                "SOphia",
                style: TextStyle(
                  color: kSecondaryColor.withOpacity(0.6),
                  fontFamily: 'CronosSPro',
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/images/sophia.png',
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SophiaMenuItem(
                    icono: FontAwesomeIcons.houseCircleCheck,
                    etiqueta: 'Consulta de OT',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SophiaConsultaOtScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class SophiaMenuItem extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final VoidCallback onTap;

  const SophiaMenuItem({
    super.key,
    required this.icono,
    required this.etiqueta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.all(12),
      style: const NeumorphicStyle(
        color: Colors.transparent,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          FaIcon(
            icono,
            color: kPrimaryColor,
          ),
          const SizedBox(
            width: 20,
          ),
          NeumorphicText(
            etiqueta,
            style: const NeumorphicStyle(
              color: kSecondaryColor,
            ),
            textStyle: NeumorphicTextStyle(
              fontFamily: 'CronosLPro',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
