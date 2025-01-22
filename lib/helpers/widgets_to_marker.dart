import 'dart:ui' as UI;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mihome_app/markers/markers.dart';

Future<BitmapDescriptor> getCustomNodoMarker(
  int minutes,
  String destination,
  bool visitado,
) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(350, 150);

  final startMarker = NodoMarkerPainter(visitado);

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: UI.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getCustomTapMarker(
  int minutes,
  String destination,
  bool visitado,
) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(
    350,
    150,
  );

  final startMarker = TapMarkerPainter(
    visitado,
  );

  startMarker.paint(
    canvas,
    size,
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: UI.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(
    byteData!.buffer.asUint8List(),
  );
}

Future<BitmapDescriptor> getCustomAmpMarker(
  int minutes,
  String destination,
  bool visitado,
) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(
    350,
    150,
  );

  final startMarker = RamalMarkerPainter(
    visitado,
  );

  startMarker.paint(
    canvas,
    size,
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: UI.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(
    byteData!.buffer.asUint8List(),
  );
}

Future<BitmapDescriptor> getCustomColillaMarker(
  int minutes,
  String destination,
  bool visitado,
) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(
    350,
    150,
  );

  final startMarker = ColillaMarkerPainter(
    visitado,
  );

  startMarker.paint(
    canvas,
    size,
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: UI.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(
    byteData!.buffer.asUint8List(),
  );
}

Future<BitmapDescriptor> getTrackingMarker(int order) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(
    350,
    150,
  );

  final startMarker = TrackingMarker(order);

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: UI.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getStartCustomMarker(
    int minutes, String destination) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(500, 150);

  final startMarker = StartMarkerPainter(
    minutes: minutes,
    destination: destination,
  );

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: UI.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getEndCustomMarker(int kms, String destination) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(500, 150);

  final startMarker = EndMarkerPainter(
    kilometers: kms,
    destination: destination,
  );

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: UI.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
