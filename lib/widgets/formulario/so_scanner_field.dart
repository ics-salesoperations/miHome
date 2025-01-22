import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/formulario.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SOScannerField extends StatelessWidget {
  final Formulario campo;

  const SOScannerField({Key? key, required this.campo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ReactiveTextField(
            formControlName: '${campo.questionText}',
            validationMessages: {
              ValidationMessage.required: (control) =>
                  '${campo.questionText} es requerido',
            },
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.circular(7.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
                borderSide: const BorderSide(color: kPrimaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
                borderSide: const BorderSide(color: kPrimaryColor, width: 2),
              ),
              labelText: "${campo.questionText}",
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
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        ReactiveFormConsumer(
          builder: (context, form, child) {
            return SizedBox(
              height: 60,
              width: 60,
              child: NeumorphicButton(
                style: const NeumorphicStyle(
                  depth: 8,
                  shape: NeumorphicShape.convex,
                ),
                onPressed: () async {
                  String barcode = await FlutterBarcodeScanner.scanBarcode(
                    "#ff6666",
                    "Cancelar",
                    false,
                    ScanMode.QR,
                  );

                  final splitted = barcode.split(":");

                  form.controls['${campo.questionText}']!.value =
                      barcode == '-1' ? "" : splitted.last;
                },
                padding: const EdgeInsets.all(1),
                child: const Icon(
                  Icons.qr_code_2,
                  color: kPrimaryColor,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
