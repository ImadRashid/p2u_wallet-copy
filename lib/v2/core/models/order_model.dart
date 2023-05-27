/// Class that handles the Orders Data object

class OrdersData {
  /// [String] variable that stores the currency of the order
  String? currency;

  /// [boolean] flag that tells us whether the transaction is complete or not
  bool? isComplete;

  /// [String] variable that stores the timestamp on which order was updated.
  String? updatedAt;

  /// [String] variable that stores the ask price for the Order
  String? askPrice;

  /// [String] variable that stores the timestamp on which order was created
  String? createdAt;

  /// [String] variable that stores Orders amount
  String? amount;

  /// [boolean] flag that tells us whether the transaction is Buy or Sell
  bool? isBuy;

  /// [String] variable that stores the Orders ID
  String? id;

  /// [String] variable that stores the email of the User that created this
  /// order
  String? createdBy;

  /// [String] variable that stores the currency in which Order wants in exchange of the current
  /// currency.
  String? askCurrency;

  /// Main [Constructor] that accepts all the data members and returns [OrdersData] object.
  OrdersData({
    this.currency,
    this.isComplete,
    this.updatedAt,
    this.askPrice,
    this.createdAt,
    this.amount,
    this.isBuy,
    this.id,
    this.createdBy,
    this.askCurrency,
  });

  /// Named [Constructor] that accepts all the data members in JSON format and
  /// returns [OrdersData]
  OrdersData.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    isComplete = json['isComplete'];
    updatedAt = json['updatedAt'];
    askPrice = json['askPrice'].toString();
    createdAt = json['createdAt'];
    amount = json['amount'].toString();
    isBuy = json['isBuy'];
    id = json['id'];
    createdBy = json['createdBy'];
    askCurrency = json['askCurrency'];
  }

  /// [Function] that converts all the data members into JSON Format.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['isComplete'] = this.isComplete;
    data['updatedAt'] = this.updatedAt;
    data['askPrice'] = this.askPrice;
    data['createdAt'] = this.createdAt;
    data['amount'] = this.amount;
    data['isBuy'] = this.isBuy;
    data['id'] = this.id;
    data['createdBy'] = this.createdBy;
    data['askCurrency'] = this.askCurrency;
    return data;
  }
}
