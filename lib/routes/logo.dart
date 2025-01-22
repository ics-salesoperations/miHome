import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: width * 0.3,
        child: const Image(
          image: AssetImage('assets/images/logo_so.png'),
        ),
      ),
    );
  }
}

class LogoSOShapePathProvider extends NeumorphicPathProvider {
  @override
  bool shouldReclip(NeumorphicPathProvider oldClipper) {
    return true;
  }

  @override
  Path getPath(Size size) {
    return Path()
      ..moveTo(5, (size.height / 2) - 3)
      ..lineTo((size.width / 3) - 10, 15)
      ..lineTo((size.width / 3) - 3, 10)
      ..lineTo((size.width * 2 / 3) + 4, 9)
      ..lineTo((size.width * 2 / 3) + 9, 13)
      ..lineTo(size.width - 5, (size.height / 2) - 3)
      ..lineTo(size.width - 5, (size.height / 2) + 3)
      ..lineTo((size.width * 2 / 3) + 10, size.height - 15)
      ..lineTo((size.width * 2 / 3) + 5, size.height - 10)
      ..lineTo((size.width / 3) - 4, size.height - 10)
      ..lineTo((size.width / 3) - 8, size.height - 12)
      ..lineTo(5, (size.height / 2) + 2);
  }

  @override
  bool get oneGradientPerPath => false;
}
