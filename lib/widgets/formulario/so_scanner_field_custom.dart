import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SOScannerFieldCustom extends StatelessWidget {
  final String campo;
  final String label;

  const SOScannerFieldCustom({
    Key? key,
    required this.campo,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ReactiveTextField(
            formControlName: campo,
            validationMessages: {
              ValidationMessage.required: (control) => '$label es requerido',
            },
            readOnly: false,
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
                    ScanMode.BARCODE,
                  );
                  form.controls[campo]!.value =
                      barcode.toLowerCase() == '-1' ? "" : barcode;
                },
                padding: const EdgeInsets.all(0),
                child: const Icon(
                  FontAwesomeIcons.barcode,
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
