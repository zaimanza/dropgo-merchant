import 'package:dropgo/providers/amplify_provider.dart';
import 'package:dropgo/providers/vendor_provider.dart';
import 'package:dropgo/screens/logged_in/home_screen.dart';
import 'package:dropgo/screens/start_screen.dart';
import 'package:dropgo/services/firebase_messaging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphQl/graph_ql_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCcpCQLFOxutW1lrW1MWODl5JSYI5D0VQs",
      appId: "1:137401177883:web:1efdf6ce7eabaab39ee5be",
      messagingSenderId: "137401177883",
      projectId: "dropgo-a2b7d",
    ),
  );
  await initHiveForFlutter();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initFCMState();
    context.read(vendorProvider).initState();
    context.read(amplifyProvider).initAmplifyFlutter();
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drop Go',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Consumer(
            builder: (context, watch, child) {
              return watch(vendorProvider).initialPrefCall == true
                  ? watch(vendorProvider).accessToken != ""
                      ? const HomeScreen()
                      : const StartScreen()
                  : const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
