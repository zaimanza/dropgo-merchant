import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/const/regex.dart';
import 'package:dropgo/graphQl/graph_ql_api.dart';
import 'package:dropgo/graphQl/profile/update_vendor.dart';
import 'package:dropgo/providers/connectivity_provider.dart';
import 'package:dropgo/providers/vendor_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController emailController = TextEditingController();
  bool isEmailEmpty = false;
  bool isEmailErr = false;

  TextEditingController passwordController = TextEditingController();
  bool isPassEmpty = false;
  bool isPassErr = false;

  TextEditingController fullNameController = TextEditingController();
  bool isFullNameEmpty = false;
  bool isFullNameErr = false;

  TextEditingController pNumberController = TextEditingController();
  bool isPNumberEmpty = false;
  bool isPNumberErr = false;

  bool isLoadingCircularOn = false;

  bool obscureText = true;
  void _toggle() {
    // Function toggle hide and show password
    setState(
      () {
        obscureText = !obscureText;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    emailController.text = context.read(vendorProvider).vendorModel.email;
    fullNameController.text = context.read(vendorProvider).vendorModel.name;
    pNumberController.text = context.read(vendorProvider).vendorModel.pNumber;
  }

  updateVendorGQL(updateVendorObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print(updateVendorObj);
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(updateVendor),
        variables: updateVendorObj,
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
      context.read(vendorProvider).updateVendorModel(
            emailController.text,
            fullNameController.text,
            pNumberController.text,
          );
      Navigator.of(context).pop();
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
            title: const Text(
              "Update profile",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.96),
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
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Stack(
                        children: [
                          AutofillGroup(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
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
                                        isFullNameEmpty = false;
                                        isFullNameErr = false;
                                      });
                                    },
                                    controller: fullNameController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Full Name",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.only(left: 40),
                                    ),
                                  ),
                                ),
                                if (isFullNameEmpty || isFullNameErr) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Name cannot have numbers or symbols.",
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
                                Container(
                                  height: 50,
                                  decoration: const ShapeDecoration(
                                    color: Colors.white,
                                    shape: StadiumBorder(),
                                  ),
                                  child: TextFormField(
                                    autofillHints: const [
                                      AutofillHints.telephoneNumber
                                    ],
                                    buildCounter: (BuildContext context,
                                            {required currentLength,
                                            maxLength,
                                            required isFocused}) =>
                                        null,
                                    maxLength: 11,
                                    onChanged: (value) {
                                      setState(() {
                                        isPNumberEmpty = false;
                                        isPNumberErr = false;
                                      });
                                    },
                                    controller: pNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Phone number",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.only(left: 40),
                                    ),
                                  ),
                                ),
                                if (isPNumberEmpty || isPNumberErr) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Must only be numbers.",
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
                                        isEmailEmpty = false;
                                        isEmailErr = false;
                                      });
                                    },
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.only(left: 40),
                                    ),
                                  ),
                                ),
                                if (isEmailEmpty || isEmailErr) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Not a valid email. Email needs to contain '@' and '.'",
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
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: const ShapeDecoration(
                                    color: Colors.white,
                                    shape: StadiumBorder(),
                                  ),
                                  child: TextFormField(
                                    buildCounter: (BuildContext context,
                                            {required currentLength,
                                            maxLength,
                                            required isFocused}) =>
                                        null,
                                    maxLength: 128,
                                    onChanged: (value) {
                                      setState(() {
                                        isPassEmpty = false;
                                        isPassErr = false;
                                      });
                                    },
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                        left: 40,
                                        top: 20,
                                        bottom: 14,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: _toggle,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    obscureText: obscureText,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (fullNameController.text.isEmpty) {
                                      setState(() {
                                        isFullNameEmpty = true;
                                      });
                                    } else {
                                      if (!regName
                                          .hasMatch(fullNameController.text)) {
                                        isFullNameErr = false;
                                      } else {
                                        isFullNameErr = true;
                                      }
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
                                    if (emailController.text.isEmpty) {
                                      setState(() {
                                        isEmailEmpty = true;
                                      });
                                    } else {
                                      if (EmailValidator.validate(
                                        emailController.text,
                                      )) {
                                        isEmailErr = false;
                                      } else {
                                        isEmailErr = true;
                                      }
                                    }

                                    if (fullNameController.text.isNotEmpty &&
                                        pNumberController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty) {
                                      Map<String, dynamic> updateVendorObj = {};
                                      //Check Email
                                      setState(() {
                                        isFullNameErr = isFullNameEmpty = false;
                                        isPNumberErr = isPNumberEmpty = false;
                                        isEmailErr = isEmailEmpty = false;
                                        isPassErr = isPassEmpty = false;

                                        //Check Full Name
                                        if (!regName.hasMatch(
                                            fullNameController.text)) {
                                          isFullNameErr = false;
                                          if (fullNameController.text !=
                                              context
                                                  .read(vendorProvider)
                                                  .vendorModel
                                                  .name) {
                                            updateVendorObj['name'] =
                                                fullNameController.text;
                                          }
                                        } else {
                                          isFullNameErr = true;
                                        }

                                        //Check Phone Number
                                        if (!regExpPNumber
                                            .hasMatch(pNumberController.text)) {
                                          isPNumberErr = false;
                                          if (pNumberController.text
                                                  .replaceAll(' ', '') !=
                                              context
                                                  .read(vendorProvider)
                                                  .vendorModel
                                                  .pNumber) {
                                            updateVendorObj['pNumber'] =
                                                "+6" + pNumberController.text;
                                          }
                                        } else {
                                          isPNumberErr = true;
                                        }

                                        //Check Email
                                        if (EmailValidator.validate(
                                          emailController.text,
                                        )) {
                                          isEmailErr = false;
                                          if (emailController.text
                                                  .replaceAll(' ', '') !=
                                              context
                                                  .read(vendorProvider)
                                                  .vendorModel
                                                  .email) {
                                            updateVendorObj['email'] =
                                                emailController.text;
                                          }
                                        } else {
                                          isEmailErr = true;
                                        }
                                        //Check Password
                                        if (passwordController
                                            .text.isNotEmpty) {
                                          if (!regExpPassword.hasMatch(
                                              passwordController.text)) {
                                            isPassErr = false;
                                            updateVendorObj['password'] =
                                                passwordController.text;
                                          } else {
                                            isPassErr = true;
                                          }
                                        }
                                      });

                                      if (context
                                              .read(connectivityProvider)
                                              .connectionStatus ==
                                          true) {
                                        if (updateVendorObj.isNotEmpty) {
                                          TextInput.finishAutofillContext();
                                          updateVendorGQL(updateVendorObj);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Cannot update same value."),
                                            ),
                                          );
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
                                        "Update",
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
