import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/const/regex.dart';
import 'package:dropgo/graphQl/graph_ql_api.dart';
import 'package:dropgo/graphQl/merchant_auth/add_vendor.dart';
import 'package:dropgo/providers/connectivity_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    context.read(connectivityProvider).startConnectionProvider();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(connectivityProvider).disposeConnectionProvider();
  }

  addMerchantGqlController(addMerchantObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print(addMerchantObj);
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(addingVendor),
        variables: addMerchantObj,
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
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 50),
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
                                if (isPassEmpty || isPassErr) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Invalid password.",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
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
                                    if (passwordController.text.isEmpty) {
                                      setState(() {
                                        isPassEmpty = true;
                                      });
                                    } else {
                                      if (!regExpPassword
                                          .hasMatch(passwordController.text)) {
                                        isPassErr = false;
                                      } else {
                                        isPassErr = true;
                                      }
                                    }

                                    if (fullNameController.text.isNotEmpty &&
                                        pNumberController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      Map<String, dynamic> addMerchantObj = {};
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
                                          addMerchantObj['name'] =
                                              fullNameController.text;
                                        } else {
                                          isFullNameErr = true;
                                        }

                                        //Check Phone Number
                                        if (!regExpPNumber
                                            .hasMatch(pNumberController.text)) {
                                          isPNumberErr = false;
                                          addMerchantObj['pNumber'] =
                                              "+6" + pNumberController.text;
                                        } else {
                                          isPNumberErr = true;
                                        }

                                        //Check Email
                                        if (EmailValidator.validate(
                                          emailController.text,
                                        )) {
                                          isEmailErr = false;
                                          addMerchantObj['email'] =
                                              emailController.text;
                                        } else {
                                          isEmailErr = true;
                                        }
                                        //Check Password
                                        if (!regExpPassword.hasMatch(
                                            passwordController.text)) {
                                          isPassErr = false;
                                          addMerchantObj['password'] =
                                              passwordController.text;
                                        } else {
                                          isPassErr = true;
                                        }
                                      });

                                      if (context
                                              .read(connectivityProvider)
                                              .connectionStatus ==
                                          true) {
                                        if (addMerchantObj.isNotEmpty &&
                                            isPassErr == false &&
                                            isEmailErr == false) {
                                          TextInput.finishAutofillContext();
                                          addMerchantGqlController(
                                              addMerchantObj);
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
                                        "Sign Up",
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
