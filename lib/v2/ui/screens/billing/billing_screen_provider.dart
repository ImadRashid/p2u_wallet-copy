import '../../../../locator.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/base_view_model.dart';
import '../../../core/models/card.dart';
import '../../../core/services/API/payment_api_service.dart';
import '../../../core/services/auth_services.dart';

class BillingScreenProvider extends BaseViewModal {
  List<CardModel> cards = [];
  List<CardCompany> cardCompanies = [];
  final locateUser = locator<AuthServices>();
  PaymentAPIService _paymentAPI = PaymentAPIService();
  String? selectedCompanyName;
  TextEditingController loginIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  BillingScreenProvider() {
    init();
  }
  init() async {
    setState(ViewState.busy);
    await fetchUserCardFromAPI();
    await fetchCardCompanyFromAPI();

    setState(ViewState.idle);
  }

  changeSelectedCompanyName(String value) {
    selectedCompanyName = value;
    notifyListeners();
  }

  fetchUserCardFromAPI() async {
    cards = [];
    var response = await _paymentAPI.fetchUserCards();
    if (response != false) {
      var jsonCards = response["result"]["accounts"];
      jsonCards.forEach((key, value) {
        cards.add(
            CardModel.companyCard(key, response["result"]["email"], value));
      });
    }
  }

  fetchCardCompanyFromAPI() async {
    var response = await _paymentAPI.fetchCardCompanies();
    if (response != false) {
      print("comapnies fetched");
      var companies = response["result"];
      for (var company in companies) {
        cardCompanies.add(CardCompany.fromJSON(company));
      }
    }
  }

  registerNewCard() async {
    var res = {"msg": "card_not_added", "color": dangerColor10};
    final response = await _paymentAPI.createUserCard(
        company: selectedCompanyName!,
        loginID: loginIDController.text,
        password: passwordController.text);
    if (response) {
      loginIDController.clear();
      passwordController.clear();
      selectedCompanyName = null;
      res = {"msg": "card_added", "color": successColor30};
    }
    return res;
  }
}
