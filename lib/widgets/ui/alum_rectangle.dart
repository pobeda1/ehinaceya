import 'package:flutter/material.dart';

class AluminumRectangle extends StatelessWidget {
  const AluminumRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        width: double.infinity,
        height: 150,
        child: CustomPaint(
          painter: AluminumRectanglePainter(),
        ),
      ),
    );
  }
}

class AluminumRectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);

    paint.color = Colors.grey.shade700;
    paint.style = PaintingStyle.fill;

    final radius = Radius.circular(5);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
