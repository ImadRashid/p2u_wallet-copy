import 'package:flutter/material.dart';

/// A [Widget] that creates small buttons

class SwapScreenSmallButton extends StatelessWidget {
  /// [Constructor] that accepts:
  /// - [text] that acts as the title for the button
  /// - [color] that is the [Color] of the button
  /// - [onPressed] which is a function that tells the button what to do
  const SwapScreenSmallButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.color})
      : super(key: key);

  /// [Function] variable to store the onPressed Function
  final Function() onPressed;

  /// [String] that is the text to be displayed on the button
  final String text;

  /// [Color] that is the color of the button.
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 28,
      minWidth: 86,
      elevation: 0,
      onPressed: onPressed,
      // Circular Border Radius of 100
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      color: color,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
