import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roller_list/roller_list.dart';
import 'widgets/ui/alum_rectangle.dart';
part '/widgets/leska.dart';
part 'variables.dart';
part 'functions.dart';

class SlotMachine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SlotMachineState();
  }
}

class _SlotMachineState extends State<SlotMachine> {
  @override
  void initState() {
    first = 0;
    second = 0;
    third = 0;
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
        const SizedBox(
          height: 30.0,
        ),
        Container(
          width: 300,
          child: Stack(
            children: <Widget>[
              const AluminumRectangle(),
              Positioned(
                left: 20,
                right: 20,
                top: 50,
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
      randomRotationTimeInSeconds = 1;

      int left = _getWeightedRandomSlotIndex();
      int center = _getWeightedRandomSlotIndex();
      int right = _getWeightedRandomSlotIndex();
      if (left == 0) {
        left = 10;
      }
      if (center == 0) {
        center = 10;
      }
      if (right == 0) {
        right = 10;
      }
      print('left = $left, center = $center, right = $right');
      startRotation = DateTime.now();
      rotator = Timer.periodic(_rotationTimeStep, _rotateRoller);
      Future.delayed(Duration(seconds: 5)).whenComplete(() {
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
}
