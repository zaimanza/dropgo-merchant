import 'package:dropgo/const/date_format.dart';
import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/const/regex.dart';
import 'package:dropgo/graphQl/graph_ql_api.dart';
import 'package:dropgo/graphQl/receiver/check_item_status.dart';
import 'package:dropgo/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'item_order_screen.dart';

class TrackCodeScreen extends StatefulWidget {
  const TrackCodeScreen({Key? key}) : super(key: key);

  @override
  _TrackCodeScreenState createState() => _TrackCodeScreenState();
}

class _TrackCodeScreenState extends State<TrackCodeScreen> {
  TextEditingController trackCodeController = TextEditingController();
  bool isTrackCodeEmpty = false;
  bool isTrackCodeErr = false;

  bool isLoadingCircularOn = false;

  @override
  void initState() {
    super.initState();
    context.read(connectivityProvider).startConnectionProvider();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(connectivityProvider).disposeConnectionProvider();
  }

  checkItemStatusGQL(trackCodeObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print(trackCodeObj);
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(checkItemStatus),
        variables: trackCodeObj,
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
      print(result.data!["checkItemStatus"]["rider"]);

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => ItemOrderScreen(
            id: result.data!["checkItemStatus"]["_id"],
            dateCreated:
                dateFormat(result.data!["checkItemStatus"]["dateCreated"]),
            dateAccepted:
                dateFormat(result.data!["checkItemStatus"]["dateAccepted"]),
            dateFinish:
                dateFormat(result.data!["checkItemStatus"]["dateFinish"]),
            item: result.data!["checkItemStatus"]["item"],
            rider: result.data!["checkItemStatus"]["rider"] ?? {},
            trackCode: trackCodeController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.yellow,
          resizeToAvoidBottomInset: true,
          body: ScrollConfiguration(
            behavior: NoGlow(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: IntrinsicHeight(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 30,
                      ),
                      child: Stack(
                        children: [
                          AutofillGroup(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                ),
                                const Text(
                                  "Track your parcel",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: const ShapeDecoration(
                                    color: Colors.white,
                                    shape: StadiumBorder(),
                                  ),
                                  child: TextFormField(
                                    autofillHints: const [AutofillHints.email],
                                    buildCounter: (BuildContext context,
                                            {required currentLength,
                                            maxLength,
                                            required isFocused}) =>
                                        null,
                                    maxLength: 320,
                                    onChanged: (value) {
                                      setState(() {
                                        isTrackCodeEmpty = false;
                                        isTrackCodeErr = false;
                                      });
                                    },
                                    controller: trackCodeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Trackcode",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.only(left: 40),
                                    ),
                                  ),
                                ),
                                if (isTrackCodeEmpty || isTrackCodeErr) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Trackcode cannot be empty and must only contain numbers.",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (trackCodeController.text.isEmpty) {
                                      setState(() {
                                        isTrackCodeEmpty = true;
                                      });
                                    } else {
                                      if (!regExpPNumber
                                          .hasMatch(trackCodeController.text)) {
                                        isTrackCodeErr = false;
                                      } else {
                                        isTrackCodeErr = true;
                                      }
                                    }

                                    if (trackCodeController.text.isNotEmpty) {
                                      Map<String, dynamic> trackCodeObj = {};
                                      //Check Email
                                      setState(() {
                                        isTrackCodeErr =
                                            isTrackCodeEmpty = false;

                                        //Check Phone Number
                                        if (!regExpPNumber.hasMatch(
                                            trackCodeController.text)) {
                                          isTrackCodeErr = false;
                                          trackCodeObj['trackCode'] =
                                              trackCodeController.text;
                                        } else {
                                          isTrackCodeErr = true;
                                        }
                                      });

                                      if (context
                                              .read(connectivityProvider)
                                              .connectionStatus ==
                                          true) {
                                        if (trackCodeObj.isNotEmpty) {
                                          TextInput.finishAutofillContext();
                                          checkItemStatusGQL(trackCodeObj);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("No internet connection."),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightBlue,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Check parcel",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
