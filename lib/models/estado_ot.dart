// ignore_for_file: public_member_api_docs, sort_constructors_first
class EstadoOt {
  int orden;
  String nombre;
  EstadoOt({
    required this.orden,
    required this.nombre,
  });
}

List<EstadoOt> estados = [
  EstadoOt(
    orden: 0,
    nombre: 'Localizar',
  ),
  EstadoOt(
    orden: 1,
    nombre: 'Activar',
  ),
  EstadoOt(
    orden: 2,
    nombre: 'Certificar',
  ),
  EstadoOt(
    orden: 3,
    nombre: 'Liquidar',
  ),
];
