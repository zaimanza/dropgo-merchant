import 'package:dropgo/models/address_model.dart';
import 'package:dropgo/models/receiver_model.dart';

import 'address_model.dart';

class ItemModel {
  String itemState; //
  int cartId; //
  String itemImg;
  double totalPrice; //
  String itemInstruction;
  ReceiverModel receiver;
  AddressModel address;

  ItemModel(
    this.itemState,
    this.cartId,
    this.itemImg,
    this.totalPrice,
    this.itemInstruction,
    this.receiver,
    this.address,
  );

  Map toJson() => {
        'itemImg': itemImg,
        'totalPrice': totalPrice,
        'itemInstruction': itemInstruction,
        'receiver': receiver.toJson(),
        'address': address.toJson(),
      };

  ItemModel.fromJson(Map json)
      : itemState = json['itemState'],
        cartId = json['cartId'],
        itemImg = json['itemImg'],
        totalPrice = json['totalPrice'],
        itemInstruction = json['itemInstruction'],
        receiver = json['receiver'],
        address = json['address'];
}
