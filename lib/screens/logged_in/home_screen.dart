import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/graphQl/graph_ql_api.dart';
import 'package:dropgo/graphQl/order/add_order.dart';
import 'package:dropgo/providers/cart_provider.dart';
import 'package:dropgo/screens/logged_in/set_location_screen.dart';
import 'package:dropgo/screens/logged_in/success_order_screen.dart';
import 'package:dropgo/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> dropLocations = [];
  bool isLoadingCircularOn = false;
  final ValueNotifier<double> totalPriceFloatActionButton =
      ValueNotifier<double>(0);

  addOrderGql(orderObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print(orderObj);
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(addOrder),
        variables: orderObj,
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
      dropLocations.clear();
      context.read(cartProvider).clearCart();
      totalPriceFloatActionButton.value = 0.0;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => const SuccessOrderScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.yellow,
            centerTitle: true,
            title: const Text(
              "Drop Go",
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
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.yellow,
                      child: const Center(
                        child: Text("Order today with Drop Go"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 150,
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
                              child: Consumer(
                                builder: (context, watch, child) {
                                  double totalPrice = 0.0;
                                  if (watch(cartProvider).items.isNotEmpty) {
                                    dropLocations.clear();
                                    int index = 0;
                                    for (var item
                                        in watch(cartProvider).items) {
                                      totalPrice = totalPrice + item.totalPrice;
                                      int tempIndex = index;
                                      dropLocations.add(
                                        GestureDetector(
                                          onTap: () {
                                            if (context
                                                    .read(cartProvider)
                                                    .address
                                                    .fullAddr !=
                                                "") {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder:
                                                      (context, __, ___) =>
                                                          SetLocationScreen(
                                                    screenRole: 'drop location',
                                                    index: tempIndex,
                                                    cartId: item.cartId,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Please set pickup location first."),
                                                ),
                                              );
                                            }
                                          },
                                          child: Card(
                                            shadowColor: Colors.transparent,
                                            child: ListTile(
                                              title: Text(
                                                item.address.fullAddr,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              trailing: const Icon(
                                                Icons.where_to_vote_outlined,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      index++;
                                    }
                                    totalPriceFloatActionButton.value =
                                        totalPrice;
                                  } else {
                                    dropLocations.clear();
                                  }
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, __, ___) =>
                                                  const SetLocationScreen(
                                                screenRole: 'pickup location',
                                                index: -1,
                                                cartId: -1,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          shadowColor: Colors.transparent,
                                          child: ListTile(
                                            title: Text(
                                              (() {
                                                if (watch(cartProvider)
                                                        .address
                                                        .fullAddr ==
                                                    "") {
                                                  return "Pick-up Location";
                                                }
                                                return watch(cartProvider)
                                                    .address
                                                    .fullAddr;
                                              })(),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            ),
                                            // trailing:
                                            //     const Icon(Icons.adjust),
                                            trailing: (() {
                                              if (watch(cartProvider)
                                                      .address
                                                      .fullAddr ==
                                                  "") {
                                                return const Icon(Icons.adjust);
                                              }
                                              return const Icon(
                                                Icons.adjust,
                                                color: Colors.green,
                                              );
                                            })(),
                                          ),
                                        ),
                                      ),
                                      if (dropLocations.isEmpty) ...[
                                        GestureDetector(
                                          onTap: () {
                                            if (context
                                                    .read(cartProvider)
                                                    .address
                                                    .fullAddr !=
                                                "") {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, __,
                                                          ___) =>
                                                      const SetLocationScreen(
                                                    screenRole: 'drop location',
                                                    index: -1,
                                                    cartId: -1,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Please set pickup location first."),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Card(
                                            shadowColor: Colors.transparent,
                                            child: ListTile(
                                              title: Text(
                                                "Drop to...",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              trailing: Icon(Icons
                                                  .add_location_alt_outlined),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Column(
                                          children: dropLocations,
                                        ),
                                      ],
                                      if (dropLocations.length < 4) ...[
                                        GestureDetector(
                                          onTap: () {
                                            if (context
                                                    .read(cartProvider)
                                                    .items
                                                    .length ==
                                                4) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "You have reach a maximum of 4 drop location."),
                                                ),
                                              );
                                            } else {
                                              if (context
                                                      .read(cartProvider)
                                                      .address
                                                      .fullAddr !=
                                                  "") {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context, __,
                                                            ___) =>
                                                        const SetLocationScreen(
                                                      screenRole:
                                                          'drop location',
                                                      index: -1,
                                                      cartId: -1,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Please set pickup location first."),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: SizedBox(
                                            height: 65,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    // do something
                                                  },
                                                ),
                                                const Text("Add stop"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (context.read(cartProvider).items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please add a drop location"),
                  ),
                );
              }
              if (context.read(cartProvider).address.fullAddr == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please add a pickup location"),
                  ),
                );
              }
              if (context.read(cartProvider).items.isNotEmpty &&
                  context.read(cartProvider).address.fullAddr != "") {
                Map<String, dynamic> orderObj = {};
                orderObj['address'] =
                    context.read(cartProvider).address.toJson();

                var testObj = [];
                context.read(cartProvider).items.forEach((item) {
                  testObj.add(item.toJson());
                });
                orderObj['items'] = testObj;

                print("heyol");
                print(orderObj);
                addOrderGql(orderObj);
              }
            },
            label: ValueListenableBuilder<double>(
              builder: (context, value, child) {
                return Text(
                  'Confirm Order (Total RM${value.toStringAsFixed(2)})',
                  style: const TextStyle(color: Colors.black),
                );
              },
              valueListenable: totalPriceFloatActionButton,
            ),
            backgroundColor: Colors.yellow,
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
