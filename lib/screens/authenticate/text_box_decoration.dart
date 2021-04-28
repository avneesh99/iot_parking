import 'package:flutter/material.dart';

class TextBoxDecoration extends InputDecoration {
  final String hintText;
  TextBoxDecoration({this.hintText});

  @override
  final TextStyle hintStyle = TextStyle(color: Colors.grey);

  final OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.blue,width: 1.0),
  );

  final OutlineInputBorder enabledBorder =OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.blue,width: 1.0),
  );

  final OutlineInputBorder errorBorder =OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.red,width: 1.0),
  );

  final OutlineInputBorder focusedErrorBorder=OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.red,width: 1.0),
  );
}