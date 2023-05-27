import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';

class TopUpWidget extends StatelessWidget {
  const TopUpWidget({Key? key, required this.image, required this.title})
      : super(key: key);
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: greyColor20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/exchange/$image.png"),
            Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            Text(
              title,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
            )
          ],
        ),
      ),
    );
  }
}
