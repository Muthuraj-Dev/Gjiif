import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late final double _height;
  late final double _width;
  late final double _fontScale;

  Responsive(this.context) {
    // Initialize values only once when the object is created
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fontScale = MediaQuery.of(context).textScaleFactor;
  }

  double height(double percentage) {
    return _height * percentage;
  }

  double width(double percentage) {
    return _width * percentage;
  }

  double font(double size) {
    return size * _fontScale;
  }

  double padding(double percentage) {
    return _width * percentage;
  }
}
