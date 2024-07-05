import 'package:flutter/material.dart';

class Global {
  static BoxDecoration CardDecoration() {
    return const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey,
              Colors.yellow,
            ]));
  }

  static BoxDecoration BackgroundDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
          0.4,
          1
        ],
            colors: [
          Colors.white,
          Colors.grey,
        ]));
  }
}
