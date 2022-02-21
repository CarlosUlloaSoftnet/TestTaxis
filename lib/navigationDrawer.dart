import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/main.dart';
import 'package:test_project/myTrips.dart';
import 'package:test_project/routes/pageroutes.dart';

import 'createDrawerBodyItem.dart';
import 'createDrwaerHeader.dart';

class navigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
              icon: Icons.home,text: 'Inicio', onTap: () =>
              Navigator.pushReplacementNamed(context, pageRoutes.home),),
          createDrawerBodyItem(
              icon: Icons.travel_explore,text: 'Mis Viajes', onTap: () =>
          _showMyTrips,),
          Divider(),
          createDrawerBodyItem(
              icon: Icons.logout,text: 'Salir', onTap: () =>
              Navigator.pushReplacementNamed(context, pageRoutes.home),),
        ],
      ),
    );
  }
  void _showMyTrips(BuildContext context){
    final route = MaterialPageRoute(builder: (BuildContext context){
      return const MyTrips();
    });
    Navigator.of(context).push(route);
  }
  void _showMyHome(BuildContext context){
    final route = MaterialPageRoute(builder: (BuildContext context){
      return const MyApp();
    });
    Navigator.of(context).push(route);
  }
}