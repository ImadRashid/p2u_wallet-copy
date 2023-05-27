import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// A [widget] which creates  an [Icon] with a [Circle] around
/// it. When values statement checks are correct than it is a white [Icon]
/// with green [background] and during incorrect it is a grey [Icon] with
/// dark grey [background]

class CircularCheckButton extends StatelessWidget {
  /// [CircularCheckButton] constructor which accepts a [parameter]
  /// of [Color]
  const CircularCheckButton({Key? key, this.iconColor}) : super(key: key);

  /// A [color] variable which determines [color] of the [icon].
  final iconColor;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      //radius 12 is equal to width and height of 24
      radius: 12,
      backgroundColor: iconColor == Colors.white ? greenColor : greyColor10,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(Icons.check, color: iconColor, size: 16),
      ),
    );
  }
}
