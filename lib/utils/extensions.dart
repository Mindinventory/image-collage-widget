import 'package:flutter/material.dart';

extension FlatButtonStyle on ButtonStyle {
  ButtonStyle get flatButton {
    return TextButton.styleFrom(
      primary: Colors.black87,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }
}