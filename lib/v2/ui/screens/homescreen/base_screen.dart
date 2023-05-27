import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/home_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/settings/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../history/history.dart';
import '../wallet/wallet_screen.dart';

/// A [Screen] made of up [StatelessWidget] that basically acts as
/// [BaseScreen] for main screen after successful [Login]. It shows the
/// [BottomNavigationBar] and the respective screen.
class BottomNavigation extends StatefulWidget {
  /// A [integer] that store the current index of [BottomNavBar] it
  /// is on so we can keep track which [Page] is to be shown on [Tab]
  /// change.
  int? indexValue;

  /// A [constructor] that accepts an argument of type [integer] that tells us
  /// which [Page]/[Screen] to display when [BaseScreen] is called.
  BottomNavigation({required this.indexValue});
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  /// A [constant] list that contains all the pages which will
  /// be shown to user on [BottomNavBar].
  final pages = [
    HomeScreen(),
    HistoryScreen(),
    SettingScreen(),
  ];

  /// [Function] that shows a popup alert dialog when user
  /// presses back button on its [Device]'s [Navbar] instead of
  /// [BackButton] at the top left of screen.
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //Exit App title
            title: Text('exit_app'.tr),
            //Exit App Message
            content: Text('exit_app_msg'.tr),
            actions: [
              //No Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor70,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('no'.tr),
              ),

              //Yes Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor70,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('yes'.tr),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        // Render page with respect to indexValue
        body: pages[widget.indexValue!],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: greyColor20))),

          // BottomNavigationBar
          child: BottomNavigationBar(
            currentIndex: widget.indexValue!,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              setState(() {
                widget.indexValue = value;
              });
            },
            unselectedItemColor: greyColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              // Home Item
              BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svg_icons/home.svg",
                    color:
                        widget.indexValue! == 0 ? primaryColor70 : greyColor50),
                label: "home".tr,
              ),

              // History Icon
              BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/svg_icons/history.svg",
                      color: widget.indexValue! == 1
                          ? primaryColor70
                          : greyColor50),
                  label: "history".tr),

              // Settings Icon
              BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/svg_icons/setting.svg",
                      color: widget.indexValue! == 2
                          ? primaryColor70
                          : greyColor50),
                  label: "settings".tr),
            ],
          ),
        ),
      ),
    );
  }
}
