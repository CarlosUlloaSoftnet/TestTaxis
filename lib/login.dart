import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/main.dart';
import 'package:test_project/myTrips.dart';
import 'package:test_project/profile.dart';
import 'package:test_project/register.dart';

void main() {
  runApp(const MyApp());
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
        "/MapHome": (BuildContext context) => const MapHome(),
        "/LoginPage": (BuildContext context) => const LoginPage(),
        "/Register": (BuildContext context) => const Register(),
        "/Profile": (BuildContext context) => const Profile(),
      },
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          secondaryHeaderColor: Colors.white),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondoTaxi.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              color: Colors.white54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.only(
                  left: 20, bottom: 20, right: 20, top: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Usuario:"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration:
                          const InputDecoration(labelText: "Contraseña:"),
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text("Aceptar"),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.pushNamed(context, "/MapHome");
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('¿No estas resgistrado?'),
                        TextButton(
                          onPressed: () {Navigator.pushNamed(context, "/Register");},
                          child: const Text("Registrarse"),
                          style: TextButton.styleFrom(
                            primary: Colors.orange,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
