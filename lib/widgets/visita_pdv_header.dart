import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/models.dart';

class VisitaPDVHeader extends StatelessWidget {
  final OT ot;
  final String titulo;

  const VisitaPDVHeader({
    Key? key,
    required this.ot,
    required this.titulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
              fontFamily: 'Cronos-Pro',
            ),
          ),
          Text(
            ot.cliente.toString() + ' - ' + ot.nombreCliente.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontFamily: 'Cronos-Pro',
            ),
          ),
        ],
      ),
    );
  }
}
