/// Class that handles the Transactions coming for History Screen
class HistoryResponse {
  /// Stores msg coming with response
  String? msg;

  /// List of Transactions
  List<Transactions>? transactions;

  /// Stores [lastId] that is necessary for lazy loading
  String? lastId;

  /// Main [Constructor] that receives input argument of [msg], [transactions] and [lastId]
  /// and returns History Response object.
  HistoryResponse({this.msg, this.transactions, this.lastId});

  /// Named [Constructor] that accepts JSON response and returns HistoryResponse object.
  HistoryResponse.fromJson(Map<String, dynamic> json) {
    // store msg
    msg = json['msg'];
    // store transactions in List of Transactions
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
    // store lastId
    lastId = json['lastId'];
  }

  /// [Function] that converts all the [HistoryResponse] data members into
  /// a JSON Response.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    data['lastId'] = this.lastId;
    return data;
  }
}

/// Class that handles transaction with its data members
class Transactions {
  /// [String] variable that stores the currency of the transaction
  String? currency;

  /// [String] variable that stores the date on which transaction was performed
  String? createDate;

  /// [String] variable that stores from which transaction was received
  String? from;

  /// [String] variable that stores the transactions actions
  String? txAction;

  /// [String] variable that stores the transaction amount
  String? amount;

  /// [String] variable that stores the transaction ID
  String? uuid;

  /// [String] variable that stores to whom transaction was sent
  String? to;

  /// [String] variable that stores receivers email
  String? email;

  /// [String] variable that stores transaction hash address
  String? txHash;

  /// [String] variable that stores type of transaction
  String? type;

  /// Main [Constructor] that accepts all data members and returns the Transactions Object.
  Transactions(
      {this.currency,
      this.createDate,
      this.from,
      this.txAction,
      this.amount,
      this.uuid,
      this.to,
      this.email,
      this.txHash,
      this.type});

  /// Named [Constructor] that receives transaction record in JSON format and returns
  /// [Transactions] object
  Transactions.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    createDate = json['createdAt'];
    from = json['from'];
    txAction = json['tx_action'];
    amount = json['amount'].toString();
    uuid = json['uuid'];
    to = json['to'];
    email = json['email'];
    txHash = json['tx_hash'];
    type = json['type'];
  }

  /// [Function] that converts all the data members of transactions in to JSON format.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['createdAt'] = this.createDate;
    data['from'] = this.from;
    data['tx_action'] = this.txAction;
    data['amount'] = this.amount;
    data['uuid'] = this.uuid;
    data['to'] = this.to;
    data['email'] = this.email;
    data['tx_hash'] = this.txHash;
    data['type'] = this.type;
    return data;
  }
}
