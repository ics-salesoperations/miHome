import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/models.dart';

class DetalleGeoScreen extends StatefulWidget {
  final GeorreferenciaLog geo;
  final String idVisita;
  final DateTime fechaVisita;
  final String tipo;

  const DetalleGeoScreen({
    Key? key,
    required this.geo,
    required this.idVisita,
    required this.fechaVisita,
    required this.tipo,
  }) : super(key: key);

  @override
  State<DetalleGeoScreen> createState() => _DetalleGeoScreenState();
}

class _DetalleGeoScreenState extends State<DetalleGeoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          left: MediaQuery.of(context).size.width * 0.05,
        ),
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: 110,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Código: ",
                        style: TextStyle(
                          color: kFourColor,
                          fontFamily: 'CronosLPro',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.geo.codigo.toString(),
                        style: const TextStyle(
                          color: kSecondaryColor,
                          fontFamily: 'CronosLPro',
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Text(
                      widget.geo.nombre.toString(),
                      maxLines: 2,
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontFamily: 'CronosSPro',
                        fontSize: 22,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Fecha Actualización: ",
                        style: TextStyle(
                          color: kFourColor,
                          fontFamily: 'CronosLPro',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm:ss')
                            .format(widget.fechaVisita),
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
            Container(
              margin: const EdgeInsets.only(
                top: 110,
              ),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 8,
                  )
                ],
              ),
              child: ListView(
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
