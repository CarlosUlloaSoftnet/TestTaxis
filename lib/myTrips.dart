
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'navigationDrawer.dart';

class MyTrips extends StatelessWidget {
  const MyTrips({Key? key}) : super(key: key);
  static const String routeName = '/MyTrips';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Mis viajes",
      home: MyHomePage(),
    );
}
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mis viajes"),
        backgroundColor: Colors.orange,

      ),
      body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
      Card(child:ListTile(
        title: Text("Soriana San Pedro"),
        subtitle: Text("Total: \$260"),
        leading: CircleAvatar(backgroundImage: NetworkImage("https://cdn1.iconfinder.com/data/icons/maps-navigation-round-corner/512/map__basic__distance__point_to_point__map_-512.png")),
        trailing: Icon(Icons.star),
        onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Detalle de mi viaje'),
              content: Text('...'),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK')),
              ],
            );
          });
    },)),
      Card(child:ListTile(
        title: Text("Softnet Soluciones"),
        subtitle: Text("Total: \$120"),
        leading: CircleAvatar(backgroundImage: NetworkImage("https://cdn1.iconfinder.com/data/icons/maps-navigation-round-corner/512/map__basic__distance__point_to_point__map_-512.png")),
        trailing: Icon(Icons.star),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Detalle de mi viaje'),
                  content: Text('...'),
                  actions: <Widget>[
                    TextButton(onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK')),
                  ],
                );
              });
        },)),
      Card(child:ListTile(
          title: Text("Calle Gonzalitos"),
          subtitle: Text("Total: \$80"),
          leading:  CircleAvatar(backgroundImage: NetworkImage("https://cdn1.iconfinder.com/data/icons/maps-navigation-round-corner/512/map__basic__distance__point_to_point__map_-512.png")),
          trailing: Icon(Icons.star),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Detalle de mi viaje'),
                  content: Text('...'),
                  actions: <Widget>[
                    TextButton(onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK')),
                  ],
                );
              });
        },)),
      Card(child:ListTile(
          title: Text("Carls jr Humberto Lobo"),
          subtitle: Text("Total: \$140"),
          leading:  CircleAvatar(backgroundImage: NetworkImage("https://cdn1.iconfinder.com/data/icons/maps-navigation-round-corner/512/map__basic__distance__point_to_point__map_-512.png")),
          trailing: Icon(Icons.star),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Detalle de mi viaje'),
                  content: Text('...'),
                  actions: <Widget>[
                    TextButton(onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK')),
                  ],
                );
              });
        },))
      ]),
    );
  }
}
