import 'package:dropgo/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';

class SuccessOrderScreen extends StatefulWidget {
  const SuccessOrderScreen({Key? key}) : super(key: key);

  @override
  _SuccessOrderScreenState createState() => _SuccessOrderScreenState();
}

class _SuccessOrderScreenState extends State<SuccessOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/success.png"),
                    height: 150.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Order successful!",
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Your order was made successfully',
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                context.read(cartProvider).clearCart();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: const ShapeDecoration(
                    color: Colors.lightBlue,
                    shape: StadiumBorder(),
                  ),
                  child: const Center(
                    child: Text(
                      "Back to home",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
