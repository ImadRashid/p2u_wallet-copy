import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/notifications/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// A [Screen]/[View[ that shows us the [User]'s notification
/// currently not [implemented]
class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
      child: Consumer<NotificationProvider>(
        builder: (context, model, child) {
          return Scaffold(
            // appbar
            appBar: AppBar(
              title: Text("announcement".tr),
            ),
            // show empty notification widget
            body: firstUserWidget(model),
          );
        },
      ),
    );
  }

  /// [Widget] that shows the empty [Notification] screen
  Widget firstUserWidget(model) {
    return Container(
      color: greyBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SizedBox()),
          Center(
              child: Image.asset(
            "assets/my_icons/emptynotification.png",
            height: 98,
            width: 98,
          )),
          SizedBox(
            height: 32,
          ),
          Center(child: Text("nothing_to_show".tr)),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
