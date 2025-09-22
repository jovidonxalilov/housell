import 'package:flutter/cupertino.dart';

class SizeUtilsExtension {
  static final SizeUtilsExtension instance = SizeUtilsExtension._internal();
  late double screenWidth;
  late double screenHeight;

  SizeUtilsExtension._internal();

  void init(BuildContext context) {
    final mq = MediaQuery.of(context);
    screenWidth = mq.size.width;
    screenHeight = mq.size.height;
  }
}