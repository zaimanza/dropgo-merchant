import 'package:dropgo/screens/order/one_order_screen.dart';
import 'package:flutter/material.dart';

class MyOrderBox extends StatelessWidget {
  final String id;
  final String dateCreated;
  final String dateAccepted;
  final String dateFinish;
  final Map address;
  final List items;
  final Map rider;

  const MyOrderBox({
    Key? key,
    required this.id,
    required this.dateCreated,
    required this.items,
    required this.address,
    required this.dateAccepted,
    required this.dateFinish,
    required this.rider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, __, ___) => OneOrderScreen(
                id: id,
                dateCreated: dateCreated,
                dateAccepted: dateAccepted,
                dateFinish: dateFinish,
                address: address,
                items: items,
                rider: rider,
              ),
            ),
          );
        },
        child: ClipRRect(
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
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address["fullAddr"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                          ),
                          Text(
                            dateCreated,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        items.length.toString(),
                        style: const TextStyle(fontSize: 22),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
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
