part of 'slotmachine.dart';

bool finish = true;
const _rotationTimeStep = Duration(milliseconds: 100);
const _rotationTimeStep2 = Duration(milliseconds: 100);
const _rotationTimeStep3 = Duration(milliseconds: 100);
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
int? first, second, third;
final leftRoller = GlobalKey<RollerListState>();
final centerRoller = GlobalKey<RollerListState>();
final rightRoller = GlobalKey<RollerListState>();
Timer? rotator;
final Random _random = Random();
int? randomRotationTimeInSeconds;
DateTime? startRotation;
