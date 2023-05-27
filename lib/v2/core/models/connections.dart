class WalletList {
  String? email;
  List<Connections>? connections;

  WalletList({this.email, this.connections});

  WalletList.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    if (json['connections'] != null) {
      connections = <Connections>[];
      json['connections'].forEach(
        (v) {
          connections!.add(new Connections.fromJson(v));
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    if (this.connections != null) {
      data['connections'] = this.connections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Connections {
  String? keyId;
  String? token;
  String? email;
  String? platform;
  String? status;

  Connections({this.keyId, this.token, this.email, this.platform, this.status});

  Connections.fromJson(Map<String, dynamic> json) {
    keyId = json['keyId'];
    token = json['token'];
    email = json['email'];
    platform = json['platform'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyId'] = this.keyId;
    data['token'] = this.token;
    data['email'] = this.email;
    data['platform'] = this.platform;
    data['status'] = this.status;
    return data;
  }
}
