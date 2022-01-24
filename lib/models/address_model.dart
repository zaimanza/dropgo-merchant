class AddressModel {
  String latLng;
  String state;
  String city;
  String country = "Malaysia";
  String fullAddr;
  int postcode;
  String unitFloor;

  AddressModel(
    this.latLng,
    this.state,
    this.city,
    this.country,
    this.fullAddr,
    this.postcode,
    this.unitFloor,
  );

  Map toJson() => {
        'latLng': latLng,
        'state': state,
        'city': city,
        'country': country,
        'fullAddr': fullAddr,
        'postcode': postcode,
        'unitFloor': unitFloor,
      };

  AddressModel.fromJson(Map json)
      : latLng = json['latLng'],
        state = json['state'],
        city = json['city'],
        country = json['country'],
        fullAddr = json['fullAddr'],
        postcode = json['postcode'],
        unitFloor = json['unitFloor'];
}
