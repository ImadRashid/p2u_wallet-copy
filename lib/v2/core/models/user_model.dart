/// [Class] that handles User Data
class UserModel {
  /// [Wallet] variable that handles [User]'s wallet data
  Wallet? wallet;

  /// [String] variable that stores [User]'s ID
  String? id;

  /// [String] variable that stores [User]'s name
  String? name;

  /// [String] variable that stores [User]'s email
  String? email;

  /// [Double] variable that stores [User]'s total asset value
  double totalBalanceInKRW = 0.0;

  /// [Double] variable that stores [User]'s total asset Profit
  /// and Loss Percentage
  double totalBalanceTrend = 0.0;

  /// Main [Constructor] that requires:
  /// - [wallet] of type [Wallet]
  /// - [id], [name], [email] of type [String]
  UserModel({this.wallet, this.id, this.name, this.email});

  /// Named [Constructor] that assigns Map(JSON) value to data members
  UserModel.fromJson(Map json) {
    // extract user information
    json = json['user'];
    // save User Wallet Information
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    // store User ID
    id = json['id'];
    // store User Name
    name = json['name'];
    // store User Email
    email = json['email'];
  }

  /// [Function] that updates [User]'s information:
  /// - Token balance
  /// - Token price
  /// - Token Change Rate
  /// - Total Trend of Tokens in [totalBalanceTrend]
  /// - Total Worth of Tokens in [totalBalanceInKRW]
  updateTokenInfo(Map userTokens, Map tokenPrices) async {
    // total trend of tokens
    totalBalanceInKRW = 0.0;
    // total worth of tokens
    totalBalanceTrend = 0.0;
    // add tokens for user
    await wallet!.addTokens(userTokens);
    // update tokens data for user
    await wallet!.updateTokenData(tokenPrices);
    // sort tokens according to provided sequence
    //await wallet!.sortInSequence();
    // calculate total trend and balance for User
    wallet!.tokens!.forEach((element) {
      totalBalanceInKRW = totalBalanceInKRW + (element.balance!);
      totalBalanceTrend =
          totalBalanceTrend + element.balance! > 0 ? element.changeRate! : 0.0;
    });
  }
}

/// [Class] that handles [User]'s wallet data:
/// - [tokens]
/// - [onChainAddress]
/// - [offChainAddress]
class Wallet {
  /// Stores User's Tokens
  List<Token>? tokens;

  /// Stores User's onChainAddress
  String? onChainAddress;

  /// Stores User's offChainAddress
  String? offChainAddress;

  // List sequence = ['P2U', 'P2UP'];

  /// Main [Constructor] that accepts:
  /// - [tokens]
  /// - [onChainAddress]
  /// - [offChainAddress]
  Wallet({this.tokens, this.onChainAddress, this.offChainAddress});

  /// Named [Constructor] that assigns values in JSON to our model
  Wallet.fromJson(Map json) {
    onChainAddress = json['address'] ?? "null";
    offChainAddress = json['msqaddress'] ?? "null";
  }

  /// [Function] that add all tokens fetched from the [API] get_user_tokens to the
  /// list of [tokens]
  addTokens(Map json) async {
    tokens = [];
    // parse JSON
    var userTokens = json['message'];
    // check if there are any tokens or not
    if (userTokens.length != 0) {
      // if tokens available add them into list
      for (Map token in userTokens) {
        if (token['name'].toString().contains('P2U')) {
          tokens?.add(Token(
              name: token['name'],
              balance: double.parse(token['balance'].toString())));
        }
      }
    }
  }

  /// [Function] that updates token data like price and change rate.
  updateTokenData(Map json) async {
    // for each element in the user token list if there
    // is a matching currency in get_prices API assign all
    // that data to the user's token
    tokens!.forEach((element) {
      var temp = json.containsKey(element.name)
          ? json[element.name]
          : {"price": 0.0, "dayChgRate": 0.0};
      element.updateData(double.parse((temp['price'] ?? 0.0).toString()),
          double.parse((temp['dayChgRate'] ?? 0.0).toString()));
    });
  }

  // /// An [Algorithm] that sorts the Token List in specified sequence.
  // sortInSequence() async {
  //   Token? swap;
  //   for (int i = 0; i < sequence.length; ++i) {
  //     if (tokens![i].name != sequence[i]) {
  //       int targetIndex =
  //           tokens!.indexWhere((element) => element.name == sequence[i]);
  //       swap = tokens![targetIndex];
  //       tokens![targetIndex] = tokens![i];
  //       tokens![i] = swap;
  //     }
  //   }
  // }
}

/// [Class] that handles [Token] data
class Token {
  /// Stores token name
  String? name;

  /// Stores token balance
  double? balance;

  /// Stores token price
  double? price;

  /// Stores token Day Change Rate
  double? changeRate;

  /// Main [Constructor] that accepts token name and balance
  Token({this.name, this.balance});

  /// Named [Constructor] that accepts token name, price and changeRate
  /// that is written basically for [TokenPrices] model
  Token.forPrices({this.name, this.price, this.changeRate});

  /// [Function] that updates the price an change rate
  void updateData(double p, double c) {
    price = p;
    changeRate = c;
  }

  /// Convert all token data to JSON
  Map toJSON() {
    return {
      "name": name,
      "balance": balance,
      "price": price,
      "chgRate": changeRate
    };
  }
}

/// [Class] that is a basis for tracking Prices
class TokenPrices {
  /// List of tokens
  List<Token>? tokens;

  /// Main [Constructor]
  TokenPrices({this.tokens});

  /// Named [Constructor] that initializes the values for the Price Trackers list from JSON.
  TokenPrices.fromJson(Map json) {
    json.forEach((key, value) {
      tokens!.add(Token.forPrices(
          name: key, price: value['price'], changeRate: value['dayChgRate']));
    });
  }
}
