import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/routes/logo.dart';
import 'package:mihome_app/widgets/boton_azul.dart';
import 'package:mihome_app/widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final usuarioCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void validarLogin() {
    authBloc.add(
      OnLoginEvent(
        usuario: usuarioCtrl.text.trim(),
        password: passCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.autenticado) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, 'home');
              });
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Neumorphic(
                    //   padding: const EdgeInsets.all(5),
                    //   style: const NeumorphicStyle(
                    //     boxShape: NeumorphicBoxShape.circle(),
                    //     depth: 15,
                    //   ),
                    //   child: Neumorphic(
                    //     style: const NeumorphicStyle(
                    //       boxShape: NeumorphicBoxShape.circle(),
                    //       color: kSecondaryColor,
                    //       depth: 0,
                    //     ),
                    //     padding: const EdgeInsets.only(
                    //       left: 22,
                    //       top: 12,
                    //       bottom: 12,
                    //       right: 12,
                    //     ),
                    //     child: Image.asset(
                    //       'assets/images/logo.png',
                    //       width: width * 0.30,
                    //       color: Colors.white70,
                    //     ),
                    //   ),
                    // ),

                    Neumorphic(
                      padding: const EdgeInsets.all(0),
                      style: const NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white54,
                        backgroundImage: AssetImage(
                          'assets/images/logo2.png',
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: <Widget>[
                          CustomInput(
                            icon: Icons.person,
                            placeholder: 'Usuario',
                            keyboardtype: TextInputType.text,
                            textController: usuarioCtrl,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomInput(
                            icon: Icons.lock_outline,
                            placeholder: 'Contraseña',
                            keyboardtype: TextInputType.text,
                            textController: passCtrl,
                            isPassword: true,
                          ),
                          state.fallido
                              ? const SizedBox(
                                  height: 5,
                                )
                              : Container(),
                          state.fallido
                              ? Container(
                                  height: 50,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_sharp,
                                        color: kThirdColor,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          "${state.intentos} intentos fallidos. ",
                                          maxLines: 3,
                                          style: const TextStyle(
                                            color: kSecondaryColor,
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                          BotonAzul(
                            text: 'Iniciar Sesión',
                            onPressed: () => validarLogin(),
                            procesando: state.procesando,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    NeumorphicText(
                      "from",
                      style: const NeumorphicStyle(
                        color: kFourColor,
                        depth: 12,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosLPro',
                        fontSize: 16,
                      ),
                    ),
                    const Logo(
                      titulo: 'Sales Operations',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
