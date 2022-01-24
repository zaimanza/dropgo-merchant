import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/const/string_capital.dart';
import 'package:dropgo/providers/vendor_provider.dart';
import 'package:dropgo/screens/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
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
          "My Profile",
          style: TextStyle(
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
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(), //here we set the circular figure
                      color: Colors.yellow,
                    ),
                    child: Center(
                      child: Consumer(
                        builder: (context, watch, child) {
                          return Text(
                            watch(vendorProvider).vendorModel.name[0],
                            style: const TextStyle(
                              fontSize: 60,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
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
                      ),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Consumer(
                                    builder: (context, watch, child) {
                                      return Text(watch(vendorProvider)
                                          .vendorModel
                                          .name
                                          .capitalize());
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Consumer(
                                    builder: (context, watch, child) {
                                      return Text(watch(vendorProvider)
                                          .vendorModel
                                          .email);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Phone Number",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Consumer(
                                    builder: (context, watch, child) {
                                      return Text(watch(vendorProvider)
                                          .vendorModel
                                          .pNumber);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, __, ___) =>
                              const UpdateProfile(),
                        ),
                      );
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
                          "Update profile",
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
          ),
        ),
      ),
    );
  }
}
