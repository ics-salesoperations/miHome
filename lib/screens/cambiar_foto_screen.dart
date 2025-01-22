import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';

class CambiarFotoScreen extends StatefulWidget {
  @override
  State<CambiarFotoScreen> createState() => _CambiarFotoScreenState();
}

class _CambiarFotoScreenState extends State<CambiarFotoScreen> {
  late AuthBloc authBloc;
  DBService _db = DBService();

  final formFoto = FormGroup({
    'userFoto': FormControl<ImageFile>(),
  });

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 600,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(20),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      25,
                    ),
                  ),
                  depth: 4,
                  lightSource: LightSource.topLeft,
                  intensity: 0.9,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/change_photo.json',
                      width: 200,
                      height: 200,
                      animate: true,
                    ),
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(
                            12,
                          ),
                        ),
                        depth: 8,
                        lightSource: LightSource.topLeft,
                        intensity: 1,
                        color: Colors.white,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        //height: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: ReactiveForm(
                          formGroup: formFoto,
                          child: ReactiveImagePicker(
                            formControlName: "userFoto",
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              floatingLabelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'CronosSPro',
                                color: kSecondaryColor,
                              ),
                              filled: false,
                              border: InputBorder.none,
                            ),
                            inputBuilder: (onPressed) => GestureDetector(
                              onTap: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera,
                                    color: kThirdColor,
                                    size: 40,
                                  ),
                                  VerticalDivider(),
                                  Text(
                                    "Tomar foto",
                                    style: TextStyle(
                                      fontFamily: 'CronosLPro',
                                      color: kSecondaryColor,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            maxHeight: 800,
                            maxWidth: 800,
                            popupDialogBuilder: obtenerImagen,
                            imageViewBuilder: (imagen) {
                              return Image.file(
                                imagen.image!,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                            depth: 12,
                          ),
                          onPressed: () async {
                            final imageFile = File((formFoto
                                    .controls["userFoto"]!.value as ImageFile)
                                .image!
                                .path);

                            Uint8List imagebytes = await imageFile
                                .readAsBytes(); //convert to bytes
                            final imagen = base64.encode(imagebytes);

                            Usuario usuario = authBloc.state.usuario;
                            usuario = usuario.copyWith(foto: imagen);

                            await _db.updateUsuario(usuario);
                            authBloc.add(
                              OnActualizarFotoEvent(
                                foto: imagen,
                              ),
                            );
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            "Confirmar",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CronosLPro',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                            depth: 12,
                          ),
                          onPressed: () async {
                            Navigator.pop(context, false);
                          },
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CronosLPro',
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void obtenerImagen(
  BuildContext context,
  ImagePickCallback pickImage,
) {
  pickImage.call(context, ImageSource.camera);
}
