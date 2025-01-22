import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/ui/custom_snackbar.dart';
import 'package:mihome_app/app_styles.dart';

class BtnActualizarDepartamento extends StatelessWidget {
  final Function onPressed;
  const BtnActualizarDepartamento({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: kPrimaryColor,
        maxRadius: 25,
        child: IconButton(
          icon: const Icon(
            Icons.update,
            color: kScaffoldBackground,
          ),
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }
}
