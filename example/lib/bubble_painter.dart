import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  static const _radius = 20.0;
  static final _shadowColor = Colors.black.withOpacity(0.6);
  static const _shadowFilter = MaskFilter.blur(BlurStyle.solid, 2.0);

  final Color color;

  const BubblePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final triangleX = size.width * 0.2;

    canvas.drawPath(
      Path()
        ..moveTo(triangleX + 9, size.height - 7)
        ..lineTo(triangleX, size.height - 16)
        ..lineTo(triangleX + 16, size.height - 16)
        ..lineTo(triangleX + 16, size.height - 7)
        ..quadraticBezierTo(
          triangleX + 14,
          size.height - 1,
          triangleX + 9,
          size.height - 5,
        )
        ..close(),
      Paint()
        ..color = _shadowColor
        ..maskFilter = _shadowFilter
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        1,
        size.width,
        size.height - 16,
        topLeft: const Radius.circular(_radius),
        topRight: const Radius.circular(_radius),
        bottomRight: const Radius.circular(_radius),
        bottomLeft: const Radius.circular(_radius),
      ),
      Paint()
        ..color = _shadowColor
        ..maskFilter = _shadowFilter
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height - 16,
        topLeft: const Radius.circular(_radius),
        topRight: const Radius.circular(_radius),
        bottomRight: const Radius.circular(_radius),
        bottomLeft: const Radius.circular(_radius),
      ),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    final path = Path()
      ..moveTo(triangleX + 9, size.height - 7)
      ..lineTo(triangleX, size.height - 16)
      ..lineTo(triangleX + 16, size.height - 16)
      ..lineTo(triangleX + 16, size.height - 7)
      ..quadraticBezierTo(
        triangleX + 14,
        size.height - 3,
        triangleX + 9,
        size.height - 7,
      )
      ..close();

    canvas.clipPath(path);

    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          size.width,
          size.height,
        ),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
