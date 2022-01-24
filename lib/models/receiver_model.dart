class ReceiverModel {
  String name;
  String pNumber;

  ReceiverModel(
    this.name,
    this.pNumber,
  );

  Map toJson() => {
        'name': name,
        'pNumber': "+6" + pNumber,
      };

  ReceiverModel.fromJson(Map json)
      : name = json['name'],
        pNumber = json['pNumber'];
}
