import 'package:dropgo/providers/vendor_provider.dart';
import 'package:dropgo/screens/order/order_list_screen.dart';
import 'package:dropgo/screens/profile/profile_screen.dart';
import 'package:dropgo/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                context.read(vendorProvider).vendorModel.name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              accountEmail:
                  (context.read(vendorProvider).vendorModel.email != "")
                      ? Text(
                          context.read(vendorProvider).vendorModel.email,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        )
                      : null,
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        context.read(vendorProvider).vendorModel.name[0],
                      ),
                    ),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.yellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  buildMenuItem(
                    text: "Profile",
                    icon: Icons.accessibility,
                    onClicked: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, __, ___) =>
                              const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  buildMenuItem(
                    text: "My Orders",
                    icon: Icons.article_outlined,
                    onClicked: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, __, ___) =>
                              const OrderListScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  buildMenuItem(
                    text: "Logout",
                    icon: Icons.logout,
                    onClicked: () async {
                      context.read(vendorProvider).deleteSharedPreference();
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, __, ___) =>
                                const StartScreen(),
                            transitionDuration: const Duration(seconds: 0),
                          ),
                          (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.black,
    ),
    title: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
      ),
    ),
    onTap: onClicked,
  );
}
