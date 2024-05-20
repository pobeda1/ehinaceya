import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roller_list/roller_list.dart';
part 'leska.dart';

bool finish = true;

class SlotMachine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SlotMachineState();
  }
}

class _SlotMachineState extends State<SlotMachine> {
  static const _rotationTimeStep = Duration(milliseconds: 100);
  static const _rotationTimeStep2 = Duration(milliseconds: 800);
  static const _rotationTimeStep3 = Duration(milliseconds: 2000);
  final List<Widget> slots = _getSlots();
  final List<String> slotNames = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "redJohn"
  ];
  int? first, second, third, fourth;
  final leftRoller = GlobalKey<RollerListState>();
  final centerRoller = GlobalKey<RollerListState>();
  final rightRoller = GlobalKey<RollerListState>();
  Timer? rotator;
  final Random _random = Random();
  int? randomRotationTimeInSeconds;
  DateTime? startRotation;

  @override
  void initState() {
    first = 0;
    second = 0;
    third = 0;
    fourth = 0;
    super.initState();
  }

  @override
  void dispose() {
    rotator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Slot Machine',
          textScaler: TextScaler.linear(1.5),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          width: 300,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: _startRotating,
                child: Image.asset(
                  'assets/images/slot-machine.jpg',
                  width: 400,
                  height: 400,
                ),
              ),
              Positioned(
                left: 94,
                right: 94,
                bottom: 90,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          scrollType: ScrollType.goesOnlyBottom,
                          items: slots,
                          enabled: false,
                          key: leftRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              first = value - 1;
                              print(
                                  'first = $first'); // забирать выигранное значение
                            });
                          },
                        ),
                      ),
                      VerticalDivider(
                        width: 2,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          scrollType: ScrollType.goesOnlyBottom,
                          enabled: false,
                          items: slots,
                          key: centerRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              second = value - 1;
                              print(
                                  'second $second'); // забирать выигранное значение
                            });
                          },
                        ),
                      ),
                      VerticalDivider(
                        width: 2,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          scrollType: ScrollType.goesOnlyBottom,
                          enabled: false,
                          items: slots,
                          key: rightRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              third = value - 1;
                              print(
                                  'third $third'); // забирать выигранное значение
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Center(
          child: SizedBox(
            height: 50,
            width: 400,
            child: LeskaWidget(
              startRotating: _startRotating,
            ),
          ),
        ),
      ],
    );
  }

  void _startRotating() {
    if (finish == true) {
      finish = false;
      // randomRotationTimeInSeconds = _random.nextInt(5) + 3;
      randomRotationTimeInSeconds = 3;

      final int left = _getWeightedRandomSlotIndex();
      final int center = _getWeightedRandomSlotIndex();
      final int right = _getWeightedRandomSlotIndex();
      startRotation = DateTime.now();
      rotator = Timer.periodic(_rotationTimeStep, _rotateRoller);
      Future.delayed(Duration(seconds: 7)).whenComplete(() {
        setState(() {
          leftRoller.currentState?.smoothScrollToIndex(left,
              duration: _rotationTimeStep, curve: Curves.decelerate);
          centerRoller.currentState?.smoothScrollToIndex(center,
              duration: _rotationTimeStep, curve: Curves.decelerate);
          rightRoller.currentState?.smoothScrollToIndex(right,
              duration: _rotationTimeStep, curve: Curves.decelerate);
        });
      });
    }
  }

  void _rotateRoller(_) {
    if (DateTime.now().difference(startRotation!).inSeconds >
        randomRotationTimeInSeconds! + 3) {
      finish = true;

      animateController.stop();
      _finishRotating();
    } else if (DateTime.now().difference(startRotation!).inSeconds <=
        randomRotationTimeInSeconds! - 3) {
      final leftRotationTarget = _random.nextInt(3 * slots.length);

      final centerRotationTarget = _random.nextInt(3 * slots.length);
      final rightRotationTarget = _random.nextInt(3 * slots.length);

      leftRoller.currentState?.smoothScrollToIndex(centerRotationTarget,
          duration: _rotationTimeStep, curve: Curves.linear);
      centerRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
          duration: _rotationTimeStep, curve: Curves.linear);
      rightRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
          duration: _rotationTimeStep, curve: Curves.linear);
    } else {
      final leftRotationTarget = _random.nextInt(3 * slots.length);
      final centerRotationTarget = _random.nextInt(3 * slots.length);
      final rightRotationTarget = _random.nextInt(3 * slots.length);

      leftRoller.currentState?.smoothScrollToIndex(centerRotationTarget,
          duration: _rotationTimeStep, curve: Curves.decelerate);
      centerRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
          duration: _rotationTimeStep, curve: Curves.decelerate);
      rightRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
          duration: _rotationTimeStep, curve: Curves.decelerate);
    }
  }

  void _finishRotating() {
    rotator?.cancel();
    rotator = null;
  }

  static List<Widget> _getSlots() {
    List<Widget> result = [];
    for (int i = 0; i <= 9; i++) {
      result.add(Container(
        padding: EdgeInsets.all(4.0),
        color: Colors.red,
        child: SvgPicture.asset(
          "assets/hiQ_numbers/DarkGraffiti_$i.svg",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    result.add(Container(
      padding: EdgeInsets.all(4),
      color: Colors.red,
      child: SvgPicture.asset(
        "assets/red_john.svg",
      ),
    ));
    return result;
  }

  int _getWeightedRandomSlotIndex() {
    final double targetProbability =
        0.05; // 5% вероятность для последнего слота
    final int numSlots = slots.length;
    final double remainingProbability = 1.0 - targetProbability;
    final double slotProbability = remainingProbability / (numSlots - 1);

    // Генерируем случайное число от 0 до 1
    final double randomValue = _random.nextDouble();
    print('random value = $randomValue and target $targetProbability');

    if (randomValue < targetProbability) {
      return numSlots; // Последний слот
    } else {
      // Оставшиеся слоты
      double cumulativeProbability = targetProbability;
      for (int i = 0; i < numSlots - 1; i++) {
        cumulativeProbability += slotProbability;
        if (randomValue < cumulativeProbability) {
          return i;
        }
      }
    }

    return numSlots - 1; // fallback на последний слот
  }
}
