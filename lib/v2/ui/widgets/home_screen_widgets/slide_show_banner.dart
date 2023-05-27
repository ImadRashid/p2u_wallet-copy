import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A [widget] of type [StatelessWidget] that shows
/// Image with in a specific form.
class SlideShowBanner extends StatelessWidget {
  /// A [constructor] that accepts an argument [asset] of type
  /// [String] and returns the [Image] in specific format
  const SlideShowBanner({
    Key? key,
    required this.asset,
    required this.url,
  }) : super(key: key);

  /// [String] value that stores the [asset].
  final String asset;
  final String url;
  @override
  Widget build(BuildContext context) {
    //Image asset
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Image.asset(
          "assets/banners/$asset.jpg",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
