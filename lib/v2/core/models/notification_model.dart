class NotificationResponse {
  String? msg;
  String? lastId;


  NotificationResponse({this.msg, });

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    lastId = json['lastId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['lastId'] = this.lastId;
    return data;
  }
}

