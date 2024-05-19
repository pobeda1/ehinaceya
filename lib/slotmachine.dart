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
  final leftRoller = new GlobalKey<RollerListState>();
  final centerRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  Timer? rotator;
  Random _random = new Random();
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
                              third = value - 1;
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
                              fourth = value - 1;
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
        if (slotNames.length < third!)
          Text(
              "Result: ${slotNames[first!]}-${slotNames[second!]}-${slotNames[third!]}"),
        if (slotNames.length < third!)
          (first == second && first == third) ? Text("WIN!!!") : Container(),
      ],
    );
  }

  void _startRotating() {
    if (finish == true) {
      finish = false;
      // randomRotationTimeInSeconds = _random.nextInt(5) + 3;
      randomRotationTimeInSeconds = 3;
      startRotation = DateTime.now();
      rotator = Timer.periodic(_rotationTimeStep, _rotateRoller);
    }
  }

  void _rotateRoller(_) {
    if (DateTime.now().difference(startRotation!).inSeconds >
        randomRotationTimeInSeconds! + 3) {
      finish = true;
      animateController.stop();
      _finishRotating();
    } else if (DateTime.now().difference(startRotation!).inSeconds >
        randomRotationTimeInSeconds! - 3) {
      final leftRotationTarget = _random.nextInt(3 * slots.length);

      final centerLeftRotationTarget = _random.nextInt(3 * slots.length);
      final centerRightRotationTarget = _random.nextInt(3 * slots.length);
      // print('first object = $centerLeftRotationTarget'); //забирать

      leftRoller.currentState?.smoothScrollToIndex(centerLeftRotationTarget,
          duration: _rotationTimeStep2, curve: Curves.decelerate);
      centerRoller.currentState?.smoothScrollToIndex(centerRightRotationTarget,
          duration: _rotationTimeStep3, curve: Curves.decelerate);
      rightRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
          duration: _rotationTimeStep, curve: Curves.decelerate);
    } else {
      final leftRotationTarget = _random.nextInt(3 * slots.length);

      final centerLeftRotationTarget = _random.nextInt(3 * slots.length);
      final centerRightRotationTarget = _random.nextInt(3 * slots.length);

      leftRoller.currentState?.smoothScrollToIndex(centerLeftRotationTarget,
          duration: _rotationTimeStep, curve: Curves.linear);
      centerRoller.currentState?.smoothScrollToIndex(centerRightRotationTarget,
          duration: _rotationTimeStep, curve: Curves.linear);
      rightRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
          duration: _rotationTimeStep, curve: Curves.linear);
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
        color: Colors.white,
        child: SvgPicture.asset(
          "assets/hiQ_numbers/DarkGraffiti_$i.svg",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    result.add(SvgPicture.asset("assets/red_john.svg"));
    return result;
  }
}
