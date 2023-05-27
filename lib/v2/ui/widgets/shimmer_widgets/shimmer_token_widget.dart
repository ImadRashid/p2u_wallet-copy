import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// A [StatelessWidget] that displays [Container] widget when
/// the [User] tokens on the main are being loaded instead of
/// circular progress indicator
class ShimmerTokenWidget extends StatelessWidget {
  const ShimmerTokenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Token Image Part
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(color: greyColor20, shape: BoxShape.circle),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Token Name and Balance Part
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 12,
                color: greyColor20,
              ),
              SizedBox(height: 6),
              // Token Price, Trend and Value Part
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: 12,
                color: greyColor20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
