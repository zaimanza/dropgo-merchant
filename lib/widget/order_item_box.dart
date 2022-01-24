import 'package:dropgo/const/string_capital.dart';
import 'package:flutter/material.dart';

class OrderItemBox extends StatelessWidget {
  final String itemImg;
  final String itemState;
  final String trackCode;
  final String totalPrice;
  final String itemInstruction;
  final Map receiver;
  final Map address;
  const OrderItemBox({
    Key? key,
    required this.itemState,
    required this.trackCode,
    required this.itemImg,
    required this.totalPrice,
    required this.itemInstruction,
    required this.receiver,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            //pickup location
            // deliver location
            // add button. max 4
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: itemImg.startsWith("http") == true
                          ? Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                // shape: StadiumBorder(),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  itemImg,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Parcel state :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        itemState.capitalize(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Track code :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        trackCode,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Price :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "RM" + totalPrice,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Rider's instruction :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        itemInstruction.capitalize(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Receiver :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receiver["name"].toString().capitalize(),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          Text(
                            receiver["pNumber"],
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Full address :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address["fullAddr"].toString().capitalize(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "State :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address["state"].toString().capitalize(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "City :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address["city"].toString().capitalize(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Country :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address["country"].toString().capitalize(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Postcode :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address["postcode"].toString(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Unit/Floor :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address["unitFloor"],
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
