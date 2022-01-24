import 'package:dropgo/const/google_map_distance_between_two.dart';
import 'package:dropgo/const/regex.dart';
import 'package:dropgo/const/string_capital.dart';
import 'package:dropgo/models/address_model.dart';
import 'package:dropgo/models/item_model.dart';
import 'package:dropgo/models/receiver_model.dart';
import 'package:dropgo/providers/amplify_provider.dart';
import 'package:dropgo/providers/cart_provider.dart';
import 'package:dropgo/providers/connectivity_provider.dart';
import 'package:dropgo/providers/google_maps_provider.dart';
import 'package:dropgo/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SetLocationScreen extends StatefulWidget {
  final String screenRole;
  final int index;
  final int cartId;

  const SetLocationScreen({
    Key? key,
    required this.screenRole,
    required this.index,
    required this.cartId,
  }) : super(key: key);

  @override
  _SetLocationScreenState createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final panelController = PanelController();

  // TextEditingController stateController = TextEditingController();
  String dropdownValue = "Selangor";
  bool isStateEmpty = false;
  bool isStateErr = false;
  TextEditingController cityController = TextEditingController();
  bool isCityEmpty = false;
  bool isCityErr = false;
  TextEditingController fullAddrController = TextEditingController();
  bool isFullAddrEmpty = false;
  bool isFullAddrErr = false;
  TextEditingController postcodeController = TextEditingController();
  bool isPostcodeEmpty = false;
  bool isPostcodeErr = false;
  TextEditingController unitFloorController = TextEditingController();
  bool isUnitFloorEmpty = false;
  bool isUnitFloorErr = false;

  bool isItemImgEmpty = false;
  bool isItemImgErr = false;
  TextEditingController itemInstructionController = TextEditingController();
  bool isItemInstructionEmpty = false;
  bool isItemInstructionErr = false;
  TextEditingController nameController = TextEditingController();
  bool isNameEmpty = false;
  bool isNameErr = false;
  TextEditingController pNumberController = TextEditingController();
  bool isPNumberEmpty = false;
  bool isPNumberErr = false;
  final ValueNotifier<String> uploadedUrl = ValueNotifier<String>("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read(connectivityProvider).startConnectionProvider();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      context.read(googleMapsProvider).mapStyle = string;
    });
    context.read(googleMapsProvider).fullAddr = "";
    context.read(googleMapsProvider).postcode = "";
    context.read(googleMapsProvider).city = "";
    context.read(googleMapsProvider).clearMarkers();
    if (widget.screenRole == 'pickup location' &&
        context.read(cartProvider).address.fullAddr != "") {
      fullAddrController.text = context.read(cartProvider).address.fullAddr;
      postcodeController.text =
          context.read(cartProvider).address.postcode.toString();
      unitFloorController.text = context.read(cartProvider).address.unitFloor;
      dropdownValue = context.read(cartProvider).address.state;
      cityController.text = context.read(cartProvider).address.city;
      var tempLatLng = context.read(cartProvider).address.latLng.split(",");
      context.read(googleMapsProvider).settingMarker(
          LatLng(double.parse(tempLatLng[0]), double.parse(tempLatLng[1])));
    }
    if (widget.screenRole == 'drop location' &&
        context.read(cartProvider).items.isNotEmpty &&
        widget.index != -1) {
      fullAddrController.text =
          context.read(cartProvider).items[widget.index].address.fullAddr;
      postcodeController.text = context
          .read(cartProvider)
          .items[widget.index]
          .address
          .postcode
          .toString();
      unitFloorController.text =
          context.read(cartProvider).items[widget.index].address.unitFloor;
      dropdownValue =
          context.read(cartProvider).items[widget.index].address.state;
      cityController.text =
          context.read(cartProvider).items[widget.index].address.city;
      var tempLatLng = context
          .read(cartProvider)
          .items[widget.index]
          .address
          .latLng
          .split(",");
      context.read(googleMapsProvider).settingMarker(
          LatLng(double.parse(tempLatLng[0]), double.parse(tempLatLng[1])));
      uploadedUrl.value =
          context.read(cartProvider).items[widget.index].itemImg;
      itemInstructionController.text =
          context.read(cartProvider).items[widget.index].itemInstruction;
      nameController.text =
          context.read(cartProvider).items[widget.index].receiver.name;
      pNumberController.text =
          context.read(cartProvider).items[widget.index].receiver.pNumber;
    }
    context.read(locationProvider).askLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(connectivityProvider).disposeConnectionProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return (watch(locationProvider).whiteScreen == false)
            ? (watch(locationProvider).locationDeniedForeverScreen == false)
                ? watch(locationProvider).locationDeniedScreen == false
                    ? homeWidget(widget)
                    : locationDeniedWidget()
                : locationDeniedForeverWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              );
      },
    );
  }

  Widget locationDeniedWidget() {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Turn On Location",
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.location_off,
                    color: Colors.black,
                    size: 90,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("We are not able to"),
                  Text("get your location."),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 80.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, -0.2), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: GestureDetector(
                        onTap: () async {
                          context
                              .read(locationProvider)
                              .askLocationPermission();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.lightBlue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17.0),
                            child: Align(
                              alignment: Alignment(0.0, 0.0),
                              child: Center(
                                child: Text(
                                  "Find My Location",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget locationDeniedForeverWidget() {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Location Denied Forever",
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.location_off,
                    color: Colors.black,
                    size: 90,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("You have denied us from accessing"),
                  Text("your location forever. Please change"),
                  Text("the settings in your App Settings."),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 80.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, -0.2), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: GestureDetector(
                        onTap: () async {
                          LocationPermission forEverLocation =
                              await Geolocator.checkPermission();
                          if (forEverLocation == LocationPermission.always ||
                              forEverLocation ==
                                  LocationPermission.whileInUse) {
                            context.read(locationProvider).whiteScreenTrue();
                            context
                                .read(locationProvider)
                                .askLocationPermission();
                          } else {
                            await Geolocator.openAppSettings();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.lightBlue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17.0),
                            child: Align(
                              alignment: Alignment(0.0, 0.0),
                              child: Center(
                                child: Text(
                                  "Open App Settings",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget homeWidget(widget) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          (() {
            if (widget.screenRole == 'pickup location') {
              return "Pick-up Location";
            }
            return "Drop Location";
          })(),
          style: const TextStyle(color: Colors.black),
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
      ),
      body: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height,
            minHeight: 78.38274932614556,
            snapPoint: 0.5,
            controller: panelController,
            defaultPanelState: PanelState.CLOSED,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
            onPanelSlide: (slideValue) {
              // setState(() {
              //   transparentPanel = slideValue;
              //   if (slideValue <= 0.5) {
              //     transparentPanel = 0;
              //   }
              //   dissapearPanel = (8 * slideValue) - 4;
              //   backgroundPanel = (2 * slideValue) - 1;
              // });
            },
            panelBuilder: (sc) => drawerWidget(sc),
            body: Consumer(
              builder: (context, watch, child) {
                return SizedBox(
                  //GoogleMap
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: (watch(googleMapsProvider).center != null)
                      ? Stack(
                          children: [
                            GoogleMap(
                              mapToolbarEnabled: false,
                              padding: const EdgeInsets.only(bottom: 80),
                              zoomControlsEnabled: false,
                              minMaxZoomPreference:
                                  const MinMaxZoomPreference(6.5, 30),
                              onMapCreated: (GoogleMapController controller) {
                                watch(googleMapsProvider).mapController =
                                    controller;
                                watch(googleMapsProvider)
                                    .mapController
                                    .setMapStyle(
                                        watch(googleMapsProvider).mapStyle);
                              },
                              initialCameraPosition: CameraPosition(
                                target: watch(googleMapsProvider).center,
                                zoom: watch(googleMapsProvider).zoomCamera,
                              ),
                              markers: Set.from(
                                  watch(googleMapsProvider).markers.value),
                              // circles: Set.from(myCircle),
                              onLongPress: (tappedLocation) {
                                context
                                    .read(googleMapsProvider)
                                    .handleTap(tappedLocation);
                                panelController.animatePanelToSnapPoint();
                                setState(() {});
                              },
                            ),
                            Column(
                              // widget2 kecik dkt screen
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  //butang merah
                                  padding: const EdgeInsets.only(
                                    right: 16.0,
                                    bottom: 114.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        final Position _locationResult =
                                            await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high,
                                        );
                                        if (_locationResult != null) {}
                                        context
                                            .read(googleMapsProvider)
                                            .handleTap(LatLng(
                                                _locationResult.latitude,
                                                _locationResult.longitude));
                                        panelController
                                            .animatePanelToSnapPoint();
                                        setState(() {});
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                      backgroundColor: Colors.yellow,
                                      child: const Icon(
                                        Icons.gps_fixed,
                                        size: 26.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      : refreshLocation(),
                );
              },
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              return watch(amplifyProvider).isFinishUpload == false
                  ? Center(
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "hi",
                            value: double.parse(watch(amplifyProvider)
                                .uploadingValue
                                .toStringAsFixed(2)),
                          ),
                        ),
                      ),
                    )
                  : Container();
            },
          )
        ],
      ),
    );
  }

  Widget refreshLocation() {
    // print("kita panggil dia ni");
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade200,
    );
  }

  Widget drawerWidget(sc) {
    return Consumer(
      builder: (context, watch, child) {
        return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              controller: sc,
              children: <Widget>[
                const SizedBox(
                  height: 12.0,
                ),
                GestureDetector(
                  onTap: panelController.open,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: panelController.open,
                  child: const SizedBox(
                    height: 17.0,
                  ),
                ),
                GestureDetector(
                  onTap: panelController.open,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Address details",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: panelController.open,
                    child: const SizedBox(
                      height: 30.0,
                    )),
                Consumer(
                  builder: (context, watch, child) {
                    print("lalu");
                    if (context.read(googleMapsProvider).isRead == false) {
                      fullAddrController.text =
                          watch(googleMapsProvider).fullAddr;
                      postcodeController.text =
                          watch(googleMapsProvider).postcode;
                      cityController.text = watch(googleMapsProvider).city;
                      context.read(googleMapsProvider).isRead = true;
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            left: 8.0,
                            top: 15.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              // shape: StadiumBorder(),
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
                                panelController.open();
                                setState(() {
                                  isFullAddrEmpty = false;
                                  isFullAddrErr = false;
                                });
                              },
                              controller: fullAddrController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Full address",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
                              ),
                            ),
                          ),
                        ),
                        if (isFullAddrEmpty || isFullAddrErr) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Full address cannot be empty",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            left: 8.0,
                            top: 15.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              // shape: StadiumBorder(),
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
                                panelController.open();
                                setState(() {
                                  isPostcodeEmpty = false;
                                  isPostcodeErr = false;
                                });
                              },
                              controller: postcodeController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Postcode",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
                              ),
                            ),
                          ),
                        ),
                        if (isPostcodeEmpty || isPostcodeErr) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Postcode cannot be empty",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            left: 8.0,
                            top: 15.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              // shape: StadiumBorder(),
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
                                panelController.open();
                                setState(() {
                                  isUnitFloorEmpty = false;
                                  isUnitFloorErr = false;
                                });
                              },
                              controller: unitFloorController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Unit/Floor",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
                              ),
                            ),
                          ),
                        ),
                        if (isUnitFloorEmpty || isUnitFloorErr) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Unit/Floor cannot be empty",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            left: 8.0,
                            top: 15.0,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "State",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  // shape: StadiumBorder(),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: DropdownButton<String>(
                                    hint: const Text(
                                      "State",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                    ),
                                    value: dropdownValue,
                                    iconDisabledColor: Colors.transparent,
                                    iconEnabledColor: Colors.transparent,
                                    elevation: 2,
                                    dropdownColor: Colors.white,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    underline: Container(
                                      height: 0,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Selangor',
                                      'Johor',
                                      'Kedah',
                                      'Kelantan',
                                      'Kuala Lumpur',
                                      'Labuan',
                                      'Melaka',
                                      'Negeri Sembilan',
                                      'Pahang',
                                      'Penang',
                                      'Perak',
                                      'Perlis',
                                      'Sabah',
                                      'Sarawak',
                                      'Terengganu',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isStateEmpty || isStateErr) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "State cannot be empty",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            left: 8.0,
                            top: 15.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              // shape: StadiumBorder(),
                            ),
                            // decoration: const ShapeDecoration(
                            //   color: Colors.white,
                            //   shape: StadiumBorder(),
                            // ),
                            child: TextFormField(
                              autofillHints: const [AutofillHints.email],
                              buildCounter: (BuildContext context,
                                      {required currentLength,
                                      maxLength,
                                      required isFocused}) =>
                                  null,
                              maxLength: 320,
                              onChanged: (value) {
                                panelController.open();
                                setState(() {
                                  isCityEmpty = false;
                                  isCityErr = false;
                                });
                              },
                              controller: cityController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "City",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
                              ),
                            ),
                          ),
                        ),
                        if (isCityEmpty || isCityErr) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "City cannot be empty",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (widget.screenRole == 'drop location') ...[
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Text(
                                "Parcel details",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                              top: 15.0,
                            ),
                            child: ValueListenableBuilder<String>(
                              builder: (context, value, child) {
                                return value == ""
                                    ? GestureDetector(
                                        onTap: () async {
                                          uploadedUrl.value = await context
                                              .read(amplifyProvider)
                                              .upload();
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.white,
                                            // shape: StadiumBorder(),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text(
                                                  "Add Image",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.grey,
                                                  size: 24.0,
                                                  semanticLabel:
                                                      'Text to announce in accessibility modes',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          uploadedUrl.value = await context
                                              .read(amplifyProvider)
                                              .upload();
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.white,
                                            // shape: StadiumBorder(),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              value,
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.low,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                              valueListenable: uploadedUrl,
                            ),
                          ),
                          if (isItemImgEmpty || isItemImgErr) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Image cannot be empty",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                              top: 15.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                // shape: StadiumBorder(),
                              ),
                              // decoration: const ShapeDecoration(
                              //   color: Colors.white,
                              //   shape: StadiumBorder(),
                              // ),
                              child: TextFormField(
                                autofillHints: const [AutofillHints.email],
                                buildCounter: (BuildContext context,
                                        {required currentLength,
                                        maxLength,
                                        required isFocused}) =>
                                    null,
                                maxLength: 320,
                                onChanged: (value) {
                                  panelController.open();
                                  setState(() {
                                    isItemInstructionEmpty = false;
                                    isItemInstructionErr = false;
                                  });
                                },
                                controller: itemInstructionController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "Instruction to rider at delivery location",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                ),
                              ),
                            ),
                          ),
                          if (isItemInstructionEmpty ||
                              isItemInstructionErr) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Item instruction cannot be empty",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Text(
                                "Receiver details",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                              top: 15.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                // shape: StadiumBorder(),
                              ),
                              // decoration: const ShapeDecoration(
                              //   color: Colors.white,
                              //   shape: StadiumBorder(),
                              // ),
                              child: TextFormField(
                                autofillHints: const [AutofillHints.email],
                                buildCounter: (BuildContext context,
                                        {required currentLength,
                                        maxLength,
                                        required isFocused}) =>
                                    null,
                                maxLength: 320,
                                onChanged: (value) {
                                  panelController.open();
                                  setState(() {
                                    isNameEmpty = false;
                                    isNameErr = false;
                                  });
                                },
                                controller: nameController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                ),
                              ),
                            ),
                          ),
                          if (isNameEmpty || isNameErr) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Name cannot be empty",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                              top: 15.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                // shape: StadiumBorder(),
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
                                  panelController.open();
                                  setState(() {
                                    isPNumberEmpty = false;
                                    isPNumberErr = false;
                                  });
                                },
                                controller: pNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone number",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                ),
                              ),
                            ),
                          ),
                          if (isPNumberEmpty || isPNumberErr) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Phone number cannot be empty",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (widget.screenRole == 'pickup location') {
                              if (fullAddrController.text.isEmpty) {
                                setState(() {
                                  isFullAddrEmpty = true;
                                });
                              } else {
                                isFullAddrErr = false;
                              }
                              if (postcodeController.text.isEmpty) {
                                setState(() {
                                  isPostcodeEmpty = true;
                                });
                              } else {
                                if (!regExpPNumber
                                    .hasMatch(postcodeController.text)) {
                                  isPostcodeErr = false;
                                } else {
                                  isPostcodeErr = true;
                                }
                              }
                              if (unitFloorController.text.isEmpty) {
                                setState(() {
                                  isUnitFloorEmpty = true;
                                });
                              } else {
                                isUnitFloorErr = false;
                              }
                              if (dropdownValue.isEmpty) {
                                setState(() {
                                  isStateEmpty = true;
                                });
                              } else {
                                isStateErr = false;
                              }
                              if (cityController.text.isEmpty) {
                                setState(() {
                                  isCityEmpty = true;
                                });
                              } else {
                                isCityErr = false;
                              }
                              if (context.read(googleMapsProvider).center ==
                                  const LatLng(3.1390, 101.6869)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Select your location on the map."),
                                  ),
                                );
                              }
                            }
                            if (fullAddrController.text.isNotEmpty &&
                                postcodeController.text.isNotEmpty &&
                                unitFloorController.text.isNotEmpty &&
                                dropdownValue.isNotEmpty &&
                                cityController.text.isNotEmpty &&
                                context.read(googleMapsProvider).center !=
                                    const LatLng(3.1390, 101.6869)) {
                              if (context
                                      .read(connectivityProvider)
                                      .connectionStatus ==
                                  true) {
                                //store in cart
                                if (widget.screenRole == 'pickup location') {
                                  context.read(cartProvider).setPickupAddress(
                                        AddressModel(
                                          "${context.read(googleMapsProvider).center.latitude},${context.read(googleMapsProvider).center.longitude}",
                                          dropdownValue.trim().capitalize(),
                                          cityController.text
                                              .trim()
                                              .capitalize(),
                                          "malaysia",
                                          fullAddrController.text
                                              .trim()
                                              .capitalize(),
                                          int.parse(
                                              postcodeController.text.trim()),
                                          unitFloorController.text
                                              .trim()
                                              .capitalize(),
                                        ),
                                      );
                                  Navigator.pop(context);
                                }
                                if (widget.screenRole == 'drop location') {
                                  if (uploadedUrl.value == "") {
                                    setState(() {
                                      isItemImgEmpty = true;
                                    });
                                  } else {
                                    isItemImgErr = false;
                                  }
                                  if (itemInstructionController.text.isEmpty) {
                                    setState(() {
                                      isItemInstructionEmpty = true;
                                    });
                                  } else {
                                    isItemInstructionErr = false;
                                  }
                                  if (nameController.text.isEmpty) {
                                    setState(() {
                                      isNameEmpty = true;
                                    });
                                  } else {
                                    isNameErr = false;
                                  }
                                  if (pNumberController.text.isEmpty) {
                                    setState(() {
                                      isPNumberEmpty = true;
                                    });
                                  } else {
                                    if (!regExpPNumber
                                        .hasMatch(pNumberController.text)) {
                                      isPNumberErr = false;
                                    } else {
                                      isPNumberErr = true;
                                    }
                                  }
                                  List templatLang = context
                                      .read(cartProvider)
                                      .address
                                      .latLng
                                      .split(",");
                                  double distanceBetweenInMeter =
                                      calculateDistance(
                                    double.parse(templatLang[0]),
                                    double.parse(templatLang[1]),
                                    context
                                        .read(googleMapsProvider)
                                        .center
                                        .latitude,
                                    context
                                        .read(googleMapsProvider)
                                        .center
                                        .longitude,
                                  );
                                  double totalPrice = 0.0;
                                  if (distanceBetweenInMeter <= 2000) {
                                    totalPrice = 4.0;
                                  } else {
                                    totalPrice = 4.0 +
                                        ((distanceBetweenInMeter - 2000) / 500);
                                  }

                                  if (uploadedUrl.value != "" &&
                                      itemInstructionController
                                          .text.isNotEmpty &&
                                      nameController.text.isNotEmpty &&
                                      pNumberController.text.isNotEmpty) {
                                    if (widget.screenRole == 'drop location' &&
                                        context
                                            .read(cartProvider)
                                            .items
                                            .isNotEmpty &&
                                        widget.index != -1) {
                                      context.read(cartProvider).updateItem(
                                            ItemModel(
                                              "Pending",
                                              context
                                                  .read(cartProvider)
                                                  .items[widget.index]
                                                  .cartId,
                                              uploadedUrl.value,
                                              totalPrice,
                                              itemInstructionController.text
                                                  .trim()
                                                  .capitalize(),
                                              ReceiverModel(
                                                nameController.text
                                                    .trim()
                                                    .capitalize(),
                                                pNumberController.text
                                                    .trim()
                                                    .capitalize(),
                                              ),
                                              AddressModel(
                                                "${context.read(googleMapsProvider).center.latitude},${context.read(googleMapsProvider).center.longitude}",
                                                dropdownValue
                                                    .trim()
                                                    .capitalize(),
                                                cityController.text
                                                    .trim()
                                                    .capitalize(),
                                                "Malaysia",
                                                fullAddrController.text
                                                    .trim()
                                                    .capitalize(),
                                                int.parse(postcodeController
                                                    .text
                                                    .trim()),
                                                unitFloorController.text
                                                    .trim()
                                                    .capitalize(),
                                              ),
                                            ),
                                            widget.index,
                                          );
                                    } else {
                                      context.read(cartProvider).addItem(
                                            ItemModel(
                                              "Pending",
                                              context
                                                  .read(cartProvider)
                                                  .items
                                                  .length,
                                              uploadedUrl.value,
                                              totalPrice,
                                              itemInstructionController.text
                                                  .trim()
                                                  .capitalize(),
                                              ReceiverModel(
                                                nameController.text
                                                    .trim()
                                                    .capitalize(),
                                                pNumberController.text
                                                    .trim()
                                                    .capitalize(),
                                              ),
                                              AddressModel(
                                                "${context.read(googleMapsProvider).center.latitude},${context.read(googleMapsProvider).center.longitude}",
                                                dropdownValue
                                                    .trim()
                                                    .capitalize(),
                                                cityController.text
                                                    .trim()
                                                    .capitalize(),
                                                "malaysia",
                                                fullAddrController.text
                                                    .trim()
                                                    .capitalize(),
                                                int.parse(postcodeController
                                                    .text
                                                    .trim()),
                                                unitFloorController.text
                                                    .trim()
                                                    .capitalize(),
                                              ),
                                            ),
                                          );
                                    }
                                    Navigator.pop(context);
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No internet connection."),
                                  ),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                              bottom: 15.0,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: const ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: StadiumBorder(),
                              ),
                              child: Center(
                                child: Text(
                                  (() {
                                    if (widget.screenRole == 'drop location' &&
                                        context
                                            .read(cartProvider)
                                            .items
                                            .isNotEmpty &&
                                        widget.index != -1) {
                                      return "Update Location";
                                    }
                                    return "Add location";
                                  })(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.screenRole == 'drop location' &&
                            context.read(cartProvider).items.isNotEmpty &&
                            widget.index != -1) ...[
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                              context
                                  .read(cartProvider)
                                  .removeItem(widget.cartId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                left: 8.0,
                                bottom: 15.0,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: const ShapeDecoration(
                                  color: Colors.red,
                                  shape: StadiumBorder(),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 300),
              ],
            ));
      },
    );
  }
}
