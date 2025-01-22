import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/formulario.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SOSeleccionMultipleField extends StatelessWidget {
  final Formulario campo;
  final FormGroup formGroup;

  const SOSeleccionMultipleField(
      {Key? key, required this.campo, required this.formGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> valores = campo.offeredAnswer.toString().split(",");

    return ReactiveFormArray(
      formArrayName: campo.questionText,
      builder: (context, formArray, child) {
        return ReactiveForm(
          formGroup: formArray.controls[0] as FormGroup,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 14, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campo.questionText!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kSecondaryColor),
                ),
                Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  children: [
                    ...valores
                        .map((valor) => Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ReactiveSwitch.adaptive(
                                  formControlName: valor,
                                  activeColor: kPrimaryColor,
                                ),
                                Flexible(
                                  child: Text(
                                    valor,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: kSecondaryColor,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
