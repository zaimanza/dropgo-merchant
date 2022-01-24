import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

initFCMState() {
  _firebaseMessaging = FirebaseMessaging.instance;
}

getFCMToken() async {
  return _firebaseMessaging.getToken();
}
