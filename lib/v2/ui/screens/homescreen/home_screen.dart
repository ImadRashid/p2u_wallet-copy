import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/core/constants/api_endpoints.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/core/enums/token_type.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/homescreen_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/notifications/notifications.dart';
import 'package:p2u_wallet/v2/ui/screens/payment/wallet_connection_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/scanning/barcode_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/swap/swaping.dart';
import 'package:p2u_wallet/v2/ui/widgets/divider_widget.dart';
import 'package:p2u_wallet/v2/ui/widgets/password_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/enums/view_state.dart';
import '../../widgets/home_screen_widgets/crypto_widget.dart';
import '../../widgets/home_screen_widgets/slide_show_banner.dart';
import '../../widgets/shimmer_widgets/shimmer_balance_widget.dart';
import '../../widgets/shimmer_widgets/shimmer_token_widget.dart';
import '../swap/p2p_transfer_screen.dart';

/// A [Screen]/[View] made up of [StatefulWidget] that acts as the main
/// screen for the application.
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double turns = 0.0;
  Duration duration = Duration(seconds: 2);

  void playSyncBalanceAnimation() {
    setState(() => turns += 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, model, child) {
        return Scaffold(
          // main app bar
          appBar: AppBar(
            centerTitle: false,
            //Application main logo
            title: Row(
              children: [
                Image.asset(
                  "assets/my_icons/p2up_logo.png",
                  color: Color(0xff11338C),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "P2U Wallet",
                    style: poppinsTextStyle(20, FontWeight.bold, Colors.black),
                  ),
                )
              ],
            ),

            automaticallyImplyLeading: false,
            actions: [
              // Barcode icon
              IconButton(
                onPressed: () {
                  Get.to(() => BarCodeScreen());
                },
                icon: Image.asset("assets/v2/scan.png",
                    scale: 2.9, color: greyColor50),
              ),

              // Notification Icon
              IconButton(
                onPressed: () {
                  Get.to(() => NotificationScreen());
                },
                icon: Image.asset(
                  "assets/v2/bell.png",
                  scale: 2.9,
                  color: greyColor50,
                ),
              ),
            ],
            // Bottom Border
            bottom: PreferredSize(
              child: DividerWidget(),
              preferredSize: Size.fromHeight(1.0),
            ),
          ),
          body: StreamBuilder(
            initialData: {"trend": "0.0", "balance": "0.0"},
            stream: model.fetchLiveBalanceAndTrend(),
            builder: (context, snapshot) {
              var trendData =
                  double.parse(model.myAppUser.totalBalanceTrend.toString());
              var balanceData =
                  double.parse(model.myAppUser.totalBalanceInKRW.toString())
                      .toStringAsFixed(3);
              if (balanceData == "0.000") {
                trendData = 0.0;
              }
              if (trendData == 0.0) {
                model.trendIcon = Icons.trending_neutral;
                model.trendColor = greyColor50;
              } else if (trendData < 0.0) {
                model.trendIcon = Icons.trending_down;
                model.trendColor = dangerColor10;
              } else {
                model.trendIcon = Icons.trending_up;
                model.trendColor = successColor30;
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await model.fetchNewBalances();
                  return;
                },
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    // Banner Slideshow
                    Container(
                      padding: EdgeInsets.symmetric(
                        // horizontal: 20,
                        vertical: 16,
                      ),
                      child: ImageSlideshow(
                        height: 150,
                        isLoop: true,
                        autoPlayInterval: 10000,
                        indicatorColor: primaryColor70,
                        indicatorBackgroundColor:
                            primaryColor70.withOpacity(0.25),
                        indicatorRadius: 3,
                        children: [
                          SlideShowBanner(
                            asset: "banner1",
                            url: "https://p2u.kr",
                          ),
                          SlideShowBanner(
                            asset: "banner2",
                            url: "https://p2u.kr",
                          ),
                          SlideShowBanner(
                            asset: "banner3",
                            url: "https://p2u.kr",
                          ),
                        ],
                      ),
                    ),
                    // Rounded Card to show balance and trend
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: greyColor20)),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  // Total Balance in KRW text
                                  child: Row(
                                    children: [
                                      Text(
                                        "Total_balance_in ".tr,
                                        style: poppinsTextStyle(
                                            14, FontWeight.w500, greyColor50),
                                      ),
                                      Text(
                                        "points".tr,
                                        style: poppinsTextStyle(
                                            14, FontWeight.w500, greyColor100),
                                      ),
                                    ],
                                  ),
                                ),
                                model.state == ViewState.busy
                                    ? Shimmer.fromColors(
                                        baseColor: greyColor20,
                                        highlightColor: greyColor0,
                                        child: ShimmerBalanceWidget(),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Text(
                                          "P $balanceData",
                                          style: poppinsTextStyle(20,
                                              FontWeight.w500, Colors.black),
                                        ),
                                      ),
                              ],
                            ),
                            AnimatedRotation(
                              turns: turns,
                              duration: duration,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: greyColor100.withOpacity(0.08),
                                child: IconButton(
                                  onPressed: () async {
                                    playSyncBalanceAnimation();
                                    await model.syncBalanceCallRPA(context);
                                  },
                                  iconSize: 20,
                                  icon: Icon(
                                    Icons.sync,
                                    color: greyColor100,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container to hold Tokens
                    Container(
                      color: greyColor0,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tokens text
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Tokens".tr,
                              style: model.locateSize.largeTextStyle,
                            ),
                          ),
                          model.state == ViewState.busy
                              ? Shimmer.fromColors(
                                  baseColor: greyColor20,
                                  highlightColor: greyColor0,
                                  child: Column(
                                    children: [
                                      ShimmerTokenWidget(),
                                      ShimmerTokenWidget(),
                                      ShimmerTokenWidget()
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount:
                                      model.myAppUser.wallet!.tokens!.length,
                                  itemBuilder: (context, index) {
                                    var token =
                                        model.myAppUser.wallet!.tokens![index];
                                    return CryptoWidget(
                                      token: token.name!,
                                      tokenBalance: token.balance,
                                      valueOfToken:
                                          '₩ ${token.price!.toStringAsFixed(2)}',
                                      valueOfBalance:
                                          '₩ ${token.price! * token.balance!}',
                                      onTap: () {
                                        Get.to(
                                          () => P2PTransferScreen(
                                            token: token.name!,
                                            balance: token.balance!,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          backgroundColor: greyColor0,
        );
      },
    );
  }
}
