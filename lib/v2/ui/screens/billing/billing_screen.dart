import 'package:flutter/material.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'package:p2u_wallet/v2/ui/widgets/divider_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/enums/view_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/setting_screen_widgets/add_card_bottom_sheet.dart';
import '../../widgets/setting_screen_widgets/credit_card_widget.dart';
import '../../widgets/shimmer_widgets/shimmer_credit_card_widget.dart';
import 'billing_screen_provider.dart';
import 'package:get/get.dart';

/// A [View] that displays the billing screen with:
/// - billing method selection
/// - add new billing method
/// - email to receive invoices
class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BillingScreenProvider(),
      child: Consumer<BillingScreenProvider>(
        builder: (context, model, child) => Scaffold(
          // Custom App Bar
          appBar: customAppBar(
            "billing".tr,
            backArrow: true,
            isBottomBorder: true,
            center: true,
          ),
          backgroundColor: greyColor0,
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              // Payment Method Label
              Text(
                "payment_method".tr,
                style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
              ),
              // Update Billing Details and Address Label
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "update_billing_details".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                ),
              ),
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: DividerWidget(),
              ),
              model.state == ViewState.busy
                  ? Shimmer.fromColors(
                      baseColor: greyColor20,
                      highlightColor: greyColor0,
                      child: Column(
                        children: [
                          ShimmerCreditCardWidget(),
                          ShimmerCreditCardWidget(),
                        ],
                      ),
                    )
                  : model.cards.length == 0
                      ? Center(
                          child: Text(
                          "no_card_added".tr,
                          style: poppinsTextStyle(
                              14, FontWeight.w500, greyColor50),
                        ))
                      : ListView.builder(
                          itemCount: model.cards.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var card = model.cards[index];
                            return CreditCardWidget(
                              companyName: card.company!,
                              email: card.email!,
                              password: card.password!,
                              isSelected: true,
                            );
                          },
                        ),
              // Add New Payment Method label
              model.state == ViewState.busy
                  ? Text("")
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      minLeadingWidth: 12,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      leading: Icon(Icons.add, color: greyColor50),
                      title: Text(
                        "add_payment_method".tr,
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor50),
                      ),
                      onTap: () {
                        // Bottom Sheet for adding new card
                        showModalBottomSheet(
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          backgroundColor: greyColor0,
                          elevation: 0,
                          context: context,
                          builder: (context) {
                            return AddCardBottomSheet(model: model);
                          },
                        );
                      },
                    ),
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: DividerWidget(),
              ),
              // Email Address Label
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "email_address".tr,
                  style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
                ),
              ),
              // Email Address Usage
              Text(
                "invoices_to_this_mail".tr,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
              ),
              // Email Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: CustomTextInputField(
                  readOnly: true,
                  keyboard: TextInputType.name,
                  prefixIcon: Icons.mail_outline_rounded,
                  controller: TextEditingController(
                    text: model.locateUser.myAppUser.email,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
