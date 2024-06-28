import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nirmaya/deptest.dart';
import 'package:nirmaya/home.dart';
import 'package:nirmaya/login.dart';
import 'package:nirmaya/notify_service.dart';
import 'package:nirmaya/profile.dart';
import 'package:nirmaya/reg.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  final Future<FirebaseApp> initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBG-icVf2sLNtECZ-uW2mvl6rEOhNDwjCw",
      appId: "1:693268736568:android:19827778bc507a610c14cd",
      messagingSenderId: "693268736568",
      projectId: "nirmaya-1c7e6",
    ),
  );

  runApp(MyApp(initialization: initialization));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> initialization;

  // Add the 'key' parameter to the constructor
  MyApp({Key? key, required this.initialization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: Text("Initializing..."),
              ),
              body: Center(
                child: CircularProgressIndicator(), // Display during loading
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: Text("Error initializing Firebase"),
              ),
              body: Center(
                child: Text("Something went wrong!"), // Display error message
              ),
            ),
          );
        }

        return Builder(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Your App',
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(
                  key: Key("LoginScreen")), // Ensure 'key' parameter exists
              '/home': (context) => HomeScreen(
                    key: Key("HomeScreen"),
                  ),
              '/registration': (context) =>
                  const RegistrationScreen(key: Key("RegistrationScreen")),
              '/test/depression': (context) =>
                  const DepressionTestScreen(key: Key("Test")),
              '/profile': (context) => ProfilePage(
                    testName: '',
                  ),
            },
            theme: ThemeData.dark(), // Ensure this is set correctly
          );
        });
      },
    );
  }
}
