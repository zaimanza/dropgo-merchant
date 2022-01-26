import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/widget/order_item_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class OneOrderScreen extends StatefulWidget {
  final String id;
  final String dateCreated;
  final String dateAccepted;
  final String dateFinish;
  final Map address;
  final List items;
  final Map rider;
  const OneOrderScreen({
    Key? key,
    required this.id,
    required this.dateCreated,
    required this.dateAccepted,
    required this.dateFinish,
    required this.address,
    required this.items,
    required this.rider,
  }) : super(key: key);

  @override
  _OneOrderScreenState createState() => _OneOrderScreenState();
}

class _OneOrderScreenState extends State<OneOrderScreen> {
  List<Widget> orderItemsBox = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var item in widget.items) {
      orderItemsBox.add(OrderItemBox(
        itemState: item["itemState"],
        trackCode: item["trackCode"],
        itemImg: item["itemImg"],
        totalPrice: item["totalPrice"].toStringAsFixed(2),
        itemInstruction: item["itemInstruction"],
        receiver: item["receiver"],
        address: item["address"],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("LALUing");
    print(widget.rider);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.address["fullAddr"],
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
          overflow: TextOverflow.fade,
          maxLines: 1,
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlow(),
        child: SingleChildScrollView(
          primary: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 6.0), //Same as `blurRadius` i guess
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
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Created",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Text(widget.dateCreated),
                                  ],
                                ),
                              ),
                              if (widget.dateAccepted != "") ...[
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          "Accepted",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(widget.dateAccepted),
                                    ],
                                  ),
                                ),
                              ],
                              if (widget.dateFinish != "") ...[
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          "Finished",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(widget.dateFinish),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (widget.rider != {}) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            bottom: 6.0), //Same as `blurRadius` i guess
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
                                const Text(
                                  "Rider's information",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.rider["name"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          widget.rider["email"],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          widget.rider["pNumber"],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          "Vehicle",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          "Plate Number: " +
                                              widget.rider["vehicle"]
                                                  ["plateNum"],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          "Type: " +
                                              widget.rider["vehicle"]["type"],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          "Model: " +
                                              widget.rider["vehicle"]
                                                  ["vehicleModel"],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 6.0), //Same as `blurRadius` i guess
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
                            children: const [
                              Text(
                                "Pickup address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 6.0), //Same as `blurRadius` i guess
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
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Full address :",
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      widget.address["fullAddr"],
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
                                      widget.address["state"],
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
                                      widget.address["city"],
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
                                      widget.address["country"],
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
                                      widget.address["postcode"].toString(),
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
                                      widget.address["unitFloor"],
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 6.0), //Same as `blurRadius` i guess
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
                            children: const [
                              Text(
                                "Parcels",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: orderItemsBox,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
