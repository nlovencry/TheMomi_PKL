import 'package:flutter/material.dart';

class CommonFunction {
  // create text
  Widget createText({
    String label = "",
    double fontSize = 14.0,
    Color fontColor = Colors.white,
    TextAlign textAlign = TextAlign.center,
    EdgeInsets padding = const EdgeInsets.all(0.0),
  }) {
    return Container(
      padding: padding,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: Color(0xFFE8CB79),
        ),
        textAlign: textAlign,
      ),
    );
  }
  Widget createIcon({
    String toolTip="",
    IconData icon=Icons.check,
    double size = 33,
    Color color = Colors.black,
    Function? onPressed,
  }) {
    return IconButton(
        icon: Icon(icon),
        color: Color(0xFFE8CB79),
        tooltip: toolTip,
        iconSize: size,
        onPressed: () {
          onPressed!();
        }
    );
  }

}
