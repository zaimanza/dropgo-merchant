import 'package:dropgo/const/date_format.dart';
import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/graphQl/graph_ql_api.dart';
import 'package:dropgo/graphQl/order/view_orders.dart';
import 'package:dropgo/providers/connectivity_provider.dart';
import 'package:dropgo/widget/my_order_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  bool isLoadingCircularOn = false;

  List<Widget> orderList = [];

  @override
  void initState() {
    super.initState();
    viewOrdersGQL();
    context.read(connectivityProvider).startConnectionProvider();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(connectivityProvider).disposeConnectionProvider();
  }

  viewOrdersGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(viewOrders),
      ),
    );

    if (result.hasException == true) {
      setState(() {
        isLoadingCircularOn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.exception!.graphqlErrors[0].message.toString()),
        ),
      );
    }

    if (result.data != null) {
      setState(() {
        isLoadingCircularOn = false;
      });
      print(result.data);
      result.data!['viewOrders'].forEach((order) {
        orderList.add(
          MyOrderBox(
            items: order["items"],
            address: order["address"],
            id: order["_id"],
            dateCreated: dateFormat(order["dateCreated"]),
            dateAccepted: dateFormat(order["dateAccepted"]),
            dateFinish: dateFormat(order["dateFinish"]),
            rider: order["rider"] ?? {},
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            title: const Text(
              "My Orders",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
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
                    children: orderList,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoadingCircularOn == true) ...[
          Center(
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ],
    );
  }
}
