import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';

class SOPhotoCustom extends StatelessWidget {
  final String campo;
  final String label;
  final FormGroup formulario;

  const SOPhotoCustom({
    Key? key,
    required this.campo,
    required this.label,
    required this.formulario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ejemplo creado");
    return ReactiveImagePicker(
      formControlName: campo,
      validationMessages: {
        ValidationMessage.required: (error) => '$label es requerido',
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        label: NeumorphicText(
          label,
          style: const NeumorphicStyle(
            color: kFourColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontFamily: 'CronosSPro',
            fontSize: 22,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: kSecondaryColor,
          ),
        ),
      ),
      inputBuilder: (onPressed) => TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.camera_alt_rounded),
        label: const Text(
          'Subir Foto',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'CronosLPro',
          ),
        ),
      ),
      maxHeight: 1024,
      maxWidth: 1024,
      popupDialogBuilder: obtenerImg,
      imageViewBuilder: (imagen) {
        return Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(20),
          child: Image.file(imagen.image!),
        );
      },
    );
  }

  void obtenerImg(
    BuildContext context,
    ImagePickCallback pickImage,
  ) async {
    pickImage.call(context, ImageSource.camera);
    final position = await Geolocator.getCurrentPosition();
    formulario.controls['latitud']!.value = position.latitude;
    formulario.controls['longitud']!.value = position.longitude;
  }
}
