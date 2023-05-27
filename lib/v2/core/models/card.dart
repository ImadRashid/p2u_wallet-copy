class CardModel {
  String? company;
  String? id;
  String? email;
  String? password;
  int? cardNumber;
  int? cvv;
  String? expiryDate;

  CardModel(
      {required this.company,
      required this.cardNumber,
      required this.cvv,
      required this.expiryDate});

  CardModel.companyCard(
      String company, String mail, Map<String, dynamic> json) {
    this.company = company;
    this.email = mail;
    this.id = json['id'];
    this.password = json['password'];
  }

  CardModel.fromJson(Map<String, dynamic> json) {
    this.company = json['company'];
    this.cardNumber = json['cardNumber'];
    this.cvv = json['cvv'];
    this.expiryDate = json['expiryData'];
  }
}

class CardCompany {
  String? code;
  String? name;
  CardCompany({this.code, this.name});
  CardCompany.fromJSON(Map<String, dynamic> json) {
    this.code = json['code'];
    this.name = json['name'];
  }
}
