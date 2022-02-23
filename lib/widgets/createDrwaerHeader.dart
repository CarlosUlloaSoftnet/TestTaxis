import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget createDrawerHeader() {
  return const UserAccountsDrawerHeader(
    accountName: Text("Carlos Ulloa"),
    accountEmail: Text("CarlosUlloa@Softnet.mx"),
    currentAccountPicture: CircleAvatar(
        radius: 50.0,
        backgroundColor: Color(0xFF778899),
        backgroundImage: NetworkImage(
            "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png")),
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.orange, Colors.white],
            end: Alignment.bottomRight)),
  );
}