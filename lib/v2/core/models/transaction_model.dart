class TransactionData {
  RequestPlatform? requestPlatform;

  TransactionData({this.requestPlatform});

  TransactionData.fromJson(Map<String, dynamic> json) {
    requestPlatform = json['request_platform'] != null
        ? new RequestPlatform.fromJson(json['request_platform'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requestPlatform != null) {
      data['request_platform'] = this.requestPlatform!.toJson();
    }
    return data;
  }
}

class RequestPlatform {
  String? status;
  String? platformUrl;
  int? expiration;
  String? userWallet;
  String? platformName;
  String? requestKey;
  String? type;
  Transaction? transaction;

  RequestPlatform(
      {this.status,
      this.platformUrl,
      this.expiration,
      this.userWallet,
      this.platformName,
      this.requestKey,
      this.type,
      this.transaction});

  RequestPlatform.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    platformUrl = json['platform_url'];
    expiration = json['expiration'];
    userWallet = json['user_wallet'];
    platformName = json['platform_name'];
    requestKey = json['request_key'];
    type = json['type'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['platform_url'] = this.platformUrl;
    data['expiration'] = this.expiration;
    data['user_wallet'] = this.userWallet;
    data['platform_name'] = this.platformName;
    data['request_key'] = this.requestKey;
    data['type'] = this.type;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Transaction {
  Token? tokens;
  String? to;

  Transaction({this.tokens, this.to});

  Transaction.fromJson(Map<String, dynamic> json) {
    tokens = json['tokens'] != null ? new Token.fromJson(json['tokens']) : null;
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tokens != null) {
      data['tokens'] = this.tokens!.toJson();
    }
    data['to'] = this.to;
    return data;
  }
}

class Tokens {
  double? mSQP;
  double? p2Up;
  double? mSQXP;

  Tokens({this.mSQP, this.p2Up, this.mSQXP});

  Tokens.fromJson(Map<String, dynamic> json) {
    mSQP = json['MSQP'];
    p2Up = json['P2UP'];
    mSQXP = json['MSQXP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MSQP'] = this.mSQP;
    data['P2UP'] = this.p2Up;
    data['MSQXP'] = this.mSQXP;
    return data;
  }
}

class Token {
  List<String?> name = [];
  List<String?> amount = [];

  Token();

  Token.fromJson(Map<String, dynamic> json) {
    for (int i = 0; i < json.length; ++i) {
      name.add(json.keys.elementAt(i).toString());
      amount.add(json.values.elementAt(i).toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}
