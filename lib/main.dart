import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nirmaya/container.dart';
import 'package:nirmaya/firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nirmaya/deptest.dart';
import 'package:nirmaya/home.dart';
import 'package:nirmaya/login.dart';
import 'package:nirmaya/profile.dart';
import 'package:nirmaya/reg.dart';
import 'anxiety_test.dart';
import 'ocd_test.dart';
import 'stress_test.dart';
import 'bipolar_test.dart';
import 'ptsd_test.dart';
import 'eating_disorder_test.dart';
import 'adhd_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future<FirebaseApp> initialization = Firebase.initializeApp(
    options: FirebaseOptions(
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

  MyApp({Key? key, required this.initialization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool?> checkIfUserIsLoggedIn() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool("isLoggedIn") ?? false;
    }

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
                child: CircularProgressIndicator(),
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
                child: Text("Something went wrong!"),
              ),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Your App',
          home: FutureBuilder<bool?>(
            future: checkIfUserIsLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data ?? false) {
                  return ContainerScreen();
                } else {
                  return LoginScreen();
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
              return ContainerScreen();
            },
          ),
          routes: {
            '/login': (context) => LoginScreen(key: Key("LoginScreen")),
            '/home': (context) => HomeScreen(key: Key("HomeScreen")),
            '/firstpage': (context) => const FirstPage(key: Key("FirstPage")),
            '/registration': (context) =>
                const RegistrationScreen(key: Key("RegistrationScreen")),
            '/test/depression': (context) =>
                const DepressionTestScreen(key: Key("DepressionTestScreen")),
            '/profile': (context) => ProfilePage(
                  testName: '',
                ),
            '/test/anxiety': (context) =>
                const AnxietyTestScreen(key: Key("AnxietyTestScreen")),
            '/test/ocd': (context) =>
                const OCDTestScreen(key: Key("OCDTestScreen")),
            '/test/stress': (context) =>
                const StressTestScreen(key: Key("StressTestScreen")),
            '/test/bipolar': (context) =>
                const BipolarTestScreen(key: Key("BipolarTestScreen")),
            '/test/ptsd': (context) =>
                const PTSDTestScreen(key: Key("PTSDTestScreen")),
            '/test/eating': (context) => const EatingDisorderTestScreen(
                key: Key("EatingDisorderTestScreen")),
            '/test/adhd': (context) =>
                const ADHDTestScreen(key: Key("ADHDTestScreen")),
          },
          theme: ThemeData.dark(),
        );
      },
    );
  }
}
