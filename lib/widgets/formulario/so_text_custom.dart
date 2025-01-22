import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SOTextFieldCustom extends StatelessWidget {
  final String campo;
  final String label;
  final bool readOnly;
  final bool toUpper;

  const SOTextFieldCustom({
    Key? key,
    required this.campo,
    required this.label,
    this.readOnly = false,
    this.toUpper = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControlName: campo,
      validationMessages: {
        ValidationMessage.required: (error) => '$label es requerido',
      },
      keyboardType: TextInputType.text,
      readOnly: readOnly,
      textCapitalization:
          toUpper ? TextCapitalization.characters : TextCapitalization.none,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: kSecondaryColor,
          fontFamily: 'CronosLPro',
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 16,
          color: kSecondaryColor,
          fontFamily: 'CronosSPro',
        ),
      ),
    );
  }
}
