import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/db_service.dart';

class DetalleFormScreen extends StatefulWidget {
  final ResumenSincronizar datos;

  const DetalleFormScreen({
    Key? key,
    required this.datos,
  }) : super(key: key);

  @override
  State<DetalleFormScreen> createState() => _DetalleFormScreenState();
}

class _DetalleFormScreenState extends State<DetalleFormScreen> {
  final DBService _db = DBService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.05),
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Neumorphic(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              child: SizedBox(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicText(
                          "Código: ",
                          style: const NeumorphicStyle(
                            color: kFourColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                          ),
                        ),
                        NeumorphicText(
                          widget.datos.codigo.toString(),
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: NeumorphicText(
                        widget.datos.tipo.toString(),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontFamily: 'CronosSPro',
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicText(
                          "Fecha Actualización: ",
                          style: const NeumorphicStyle(
                            color: kFourColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm:ss')
                              .format(widget.datos.fecha!),
                          style: const TextStyle(
                            color: kSecondaryColor,
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Neumorphic(
              margin: const EdgeInsets.only(
                top: 150,
                left: 12,
                right: 12,
                bottom: 20,
              ),
              padding: const EdgeInsets.all(12),
              child: FutureBuilder<List<DetalleAnswer>>(
                future: _db.leerRespuestasDetalle(
                  instanceId: widget.datos.idVisita.toString(),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    children: [
                      NeumorphicText(
                        "Detalle del formulario",
                        style: const NeumorphicStyle(
                          color: kPrimaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontFamily: 'CronosSPro',
                          fontSize: 22,
                        ),
                      ),
                      ...snapshot.data!
                          .map((e) => Neumorphic(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                style: const NeumorphicStyle(
                                  depth: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: NeumorphicText(
                                        e.questionText.toString() + ":",
                                        style: const NeumorphicStyle(
                                          color: kSecondaryColor,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontFamily: 'CronosLPro',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: NeumorphicText(
                                        e.response.toString(),
                                        style: const NeumorphicStyle(
                                          color: kFourColor,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontFamily: 'CronosLPro',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  );
                },
              ),

              /* child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      widget.tipo == "VISITA"
                          ? "Detalle del Producto"
                          : "Detalle del Formulario",
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 18,
                        fontFamily: 'CronosSPro',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeInLeft(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 245, 245, 243),
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Tipo: ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontFamily: 'CronosLpro',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.geo.tipo.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'CronosLpro',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInLeft(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 245, 245, 243),
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Codigo: ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontFamily: 'CronosLpro',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.geo.codigo.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'CronosLpro',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInLeft(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 245, 245, 243),
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Nombre: ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontFamily: 'CronosLpro',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.geo.nombre.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'CronosLpro',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInLeft(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 245, 245, 243),
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Localización: ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontFamily: 'CronosLpro',
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  widget.geo.latitud.toString() + ",",
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'CronosLpro',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  widget.geo.longitud.toString(),
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'CronosLpro',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInLeft(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(
                              255,
                              245,
                              245,
                              243,
                            ),
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Código Padre: ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontFamily: 'CronosLpro',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.geo.codigoPadre.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'CronosLpro',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
           */
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundColor: kFourColor.withOpacity(0.8),
                  radius: 16,
                  child: const FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 22,
                    color: kThirdColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
