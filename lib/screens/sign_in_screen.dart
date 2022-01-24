import 'package:dropgo/const/no_glow.dart';
import 'package:dropgo/const/regex.dart';
import 'package:dropgo/graphQl/graph_ql_api.dart';
import 'package:dropgo/graphQl/merchant_auth/vendor_login.dart';
import 'package:dropgo/providers/connectivity_provider.dart';
import 'package:dropgo/providers/vendor_provider.dart';
import 'package:dropgo/screens/sign_up_screen.dart';
import 'package:dropgo/services/firebase_messaging_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'logged_in/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  bool isEmailEmpty = false;
  bool isEmailErr = false;

  TextEditingController passwordController = TextEditingController();
  bool isPassEmpty = false;
  bool isPassErr = false;

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

  loginGqlController(loginObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print(loginObj);
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(vendorLogIn),
        variables: loginObj,
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
      context.read(vendorProvider).setVendorModel(result.data!['vendorLogIn']);
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, __, ___) => const HomeScreen(),
            transitionDuration: const Duration(seconds: 0),
          ),
          (route) => false);
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
                                  "Sign In",
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
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

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
                                    if (emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      Map<String, dynamic> loginObj = {};
                                      //Check Email
                                      setState(() {
                                        isEmailErr = isEmailEmpty = false;
                                        isPassErr = isPassEmpty = false;
                                        if (EmailValidator.validate(
                                          emailController.text,
                                        )) {
                                          isEmailErr = false;
                                          loginObj['email'] =
                                              emailController.text;
                                        } else {
                                          isEmailErr = true;
                                        }
                                        //Check Password
                                        if (!regExpPassword.hasMatch(
                                            passwordController.text)) {
                                          isPassErr = false;
                                          loginObj['password'] =
                                              passwordController.text;
                                        } else {
                                          isPassErr = true;
                                        }
                                      });

                                      if (context
                                              .read(connectivityProvider)
                                              .connectionStatus ==
                                          true) {
                                        if (loginObj.isNotEmpty &&
                                            isPassErr == false &&
                                            isEmailErr == false) {
                                          TextInput.finishAutofillContext();

                                          //fcmToken
                                          var fetchedFCMToken =
                                              await getFCMToken();
                                          // print(fetchedFCMToken);
                                          loginObj['fcmToken'] =
                                              fetchedFCMToken;

                                          loginGqlController(loginObj);
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
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();

                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, __, ___) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Don't have an account? Register now.",
                                    style: TextStyle(
                                      color: Colors.lightBlue,
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
