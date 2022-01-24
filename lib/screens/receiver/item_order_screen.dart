import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/widget/order_item_box.dart';
import 'package:flutter/material.dart';

class ItemOrderScreen extends StatefulWidget {
  final String trackCode;
  final String id;
  final String dateCreated;
  final String dateAccepted;
  final String dateFinish;
  final Map item;
  final Map rider;
  const ItemOrderScreen({
    Key? key,
    required this.id,
    required this.dateCreated,
    required this.dateAccepted,
    required this.dateFinish,
    required this.item,
    required this.rider,
    required this.trackCode,
  }) : super(key: key);

  @override
  _ItemOrderScreenState createState() => _ItemOrderScreenState();
}

class _ItemOrderScreenState extends State<ItemOrderScreen> {
  late Widget orderItemBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderItemBox = OrderItemBox(
      itemState: widget.item["itemState"],
      trackCode: widget.item["trackCode"],
      itemImg: widget.item["itemImg"],
      totalPrice: widget.item["totalPrice"].toStringAsFixed(2),
      itemInstruction: widget.item["itemInstruction"],
      receiver: widget.item["receiver"],
      address: widget.item["address"],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          widget.trackCode,
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
                  if (widget.rider == {}) ...[
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
                          height: 130,
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
                                      ],
                                    ),
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.green,
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
                                "Parcel information",
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
                  orderItemBox,
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
