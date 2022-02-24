import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/providers/app_state.dart';
import 'package:test_project/screens/profile.dart';
import 'package:test_project/screens/register.dart';

import '../providers/user.dart';
import 'MainMap.dart';
import 'login.dart';
import 'myTrips.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String routeName = '/MyApp';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/MyTrips": (BuildContext context) => const MyTrips(),
        "/MapHome": (BuildContext context) => const MyHomePage(),
        "/LoginPage": (BuildContext context) => const LoginPage(),
        "/Register": (BuildContext context) => const Register(),
        "/Profile": (BuildContext context) => const Profile(),
      },
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          secondaryHeaderColor: Colors.white),
      home: MyHomePage(),
    );
  }
}