part of 'slotmachine.dart';

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

int _getWeightedRandomSlotIndex() {
  final double targetProbability = 0.001; // 5% вероятность для последнего слота
  final int numSlots = slots.length;
  final double remainingProbability = 1.0 - targetProbability;
  final double slotProbability = remainingProbability / (numSlots - 1);

  // Генерируем случайное число от 0 до 1
  final double randomValue = _random.nextDouble();
  print('random value = $randomValue and target $targetProbability');

  if (randomValue < targetProbability) {
    return numSlots + 1; // Последний слот
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

List<Widget> _getSlots() {
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
