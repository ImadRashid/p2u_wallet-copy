/// Class that handles data scanned from QR Code.
class ScanData {
  /// [String] variable that stores platform name
  String platform;

  /// [String] variable that stores the request key from QR Code
  String keyId;

  /// Main [Constructor] that accepts data members and returns scan data.
  ScanData({required this.platform, required this.keyId});

  /// Named [Constructor]  that accepts data members in JSON format and
  /// returns [ScanData] object.
  ScanData.fromJson(Map<String, dynamic> json)
      : platform = json['platform'],
        keyId = json['keyId'];

  /// [Function] that converts all data members into JSON format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['platform'] = this.platform;
    data['keyId'] = this.keyId;
    return data;
  }
}
