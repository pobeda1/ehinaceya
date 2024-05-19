part of 'slotmachine.dart';

late AnimationController animateController;

class LeskaWidget extends StatefulWidget {
  final VoidCallback startRotating;
  const LeskaWidget({
    super.key,
    required this.startRotating,
  });

  @override
  _LeskaWidgetState createState() => _LeskaWidgetState();
}

class _LeskaWidgetState extends State<LeskaWidget>
    with SingleTickerProviderStateMixin {
  final Offset _startPoint = const Offset(0, 0);
  final Offset _endPoint = const Offset(200, 0);
  late Offset _currentPoint;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentPoint = Offset((_startPoint.dx + _endPoint.dx) / 2,
        (_startPoint.dy + _endPoint.dy) / 2);
    animateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPoint = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    widget.startRotating();
    animateController
        .forward(from: 0.0)
        .whenComplete(() => animateController.repeat(
              period: const Duration(milliseconds: 500),
              min: 0.0,
              max: 1.0,
            ));
    // Future.delayed(Duration(seconds: 3), () {
    //   _controller.stop();
    // });

    startAnimate();
  }

  Animation<double> startAnimate() {
    return _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Первый этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Второй этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Первый этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Второй этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Первый этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Второй этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Первый этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Второй этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Первый этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Второй этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Первый этап вибрации
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2, // Второй этап вибрации
      ),
    ]).animate(animateController)
      ..addListener(() {
        setState(() {
          // Первая часть анимации - возврат на место
          if (_animation.value == 0) {
            _currentPoint = Offset(
              _currentPoint.dx,
              _startPoint.dy +
                  (_endPoint.dy - _startPoint.dy) * (1 - _animation.value),
            );
          }
          // Вторая часть анимации - вибрация
          else {
            double vibration =
                (1 - (_animation.value - 1.0)) * 3; // амплитуда вибрации
            _currentPoint = Offset(
              _currentPoint.dx,
              _startPoint.dy + vibration * (1 - _animation.value),
            );
          }
        });
      });
  }

  @override
  void dispose() {
    animateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !finish,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: SizedBox(
          height: 10,
          child: CustomPaint(
            painter: StringPainter(
              startPoint: _startPoint,
              endPoint: _endPoint,
              currentPoint: _currentPoint,
            ),
          ),
        ),
      ),
    );
  }
}

class StringPainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final Offset currentPoint;

  StringPainter({
    required this.startPoint,
    required this.endPoint,
    required this.currentPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw the string
    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..quadraticBezierTo(
        currentPoint.dx,
        currentPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
