class WalletConnection {
  String? id;
  String? userEmail;
  String? status;
  String? platformUrl;
  String? platformName;
  WalletConnection();
  WalletConnection.fromJson(Map json) {
    id = json["uuid"];
    userEmail = json["user_id"];
    status = json["status"];
    platformUrl = json["platform_url"];
    platformName = json["platform_name"];
  }
}
