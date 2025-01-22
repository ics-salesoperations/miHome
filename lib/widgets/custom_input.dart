import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/blocs/auth/auth_bloc.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardtype;
  final bool isPassword;

  const CustomInput({
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardtype = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            25,
          ),
        ),
        depth: -5,
        lightSource: LightSource.topLeft,
        intensity: 0.8,
        surfaceIntensity: 1,
        color: Colors.white12,
      ),
      child: TextField(
        controller: textController,
        autocorrect: false,
        obscureText: isPassword ? !_authBloc.state.showPass : isPassword,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: placeholder,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _authBloc.state.showPass
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    _authBloc.add(OnToggleShowPassEvent());
                  },
                )
              : null,
        ),
      ),
    );
  }
}
