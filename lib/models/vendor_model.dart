class VendorModel {
  String id;
  String name;
  String email;
  String pNumber;
  String createAt;
  String updateAt;
  List<String> orders;
  String accessToken;
  VendorModel(
    this.id,
    this.name,
    this.email,
    this.pNumber,
    this.createAt,
    this.updateAt,
    this.orders,
    this.accessToken,
  );

  Map toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pNumber': pNumber,
        'createAt': createAt,
        'updateAt': updateAt,
        'orders': orders.join(","),
        'accessToken': accessToken,
      };

  VendorModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        pNumber = json['pNumber'],
        createAt = json['createAt'],
        updateAt = json['updateAt'],
        orders = json['orders'],
        accessToken = json['accessToken'];
}
