import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmptyListingWidget extends StatelessWidget {
  const EmptyListingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/v2/empty.svg"),
            SizedBox(
              height: 5,
            ),
            Text("p2p_listings_empty".tr),
          ],
        ),
      ),
    );
  }
}
