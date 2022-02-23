import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Perfil"),
        backgroundColor: Colors.orange,
      ),
      body: Card(
        color: Colors.white54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin:
        const EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(image: NetworkImage(
                          "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png") , fit: BoxFit.fill  ),)
                      // image: DecorationImage(image: AssetImage('assets/taxi.png'),),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const <Widget>[
                  TextField(
                    enabled: false,
                      decoration: InputDecoration(
                        labelText: "Nombre", //babel text
                        hintText: "Carlos Ulloa", //hint text
                        prefixIcon: Icon(Icons.people), //prefix iocn
                        hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), //hint text style
                        labelStyle: TextStyle(fontSize: 13, color: Colors.orange), //label style
                      ),
                  ),
                  SizedBox(height: 20),
                  Text('Nombre : Carlos Ulloa', style: TextStyle(fontSize: 25),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
