import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:slotmachine/slotmachine.dart';

void main() {
  runApp(const MainApp());
}

List<Widget> _values = [
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_0.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_1.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_2.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_3.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_4.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_5.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_6.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_7.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_8.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/hiQ_numbers/DarkGraffiti_9.svg',
    width: 100,
    height: 100,
  ),
  SvgPicture.asset(
    'assets/red_john.svg',
    width: 100,
    height: 100,
  ),
];

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[600],
        body: Center(child: SlotMachine()),
      ),
    );
  }
}
