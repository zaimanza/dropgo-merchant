import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../amplifyconfiguration.dart';

final amplifyProvider = ChangeNotifierProvider((ref) => AmplifyProvider());
final AmplifyProvider amplifyProviderVar = AmplifyProvider();

class AmplifyProvider extends ChangeNotifier {
  bool isAmplifyConfigured = false;

  initAmplifyFlutter() async {
    AmplifyAuthCognito auth = AmplifyAuthCognito();
    AmplifyStorageS3 storage = AmplifyStorageS3();
    AmplifyAnalyticsPinpoint analytics = AmplifyAnalyticsPinpoint();

    Amplify.addPlugins([auth, storage, analytics]);

    // Initialize AmplifyFlutter
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }

    isAmplifyConfigured = true;
    notifyListeners();
  }
}
