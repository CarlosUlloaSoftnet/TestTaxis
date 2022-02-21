import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Registrar"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Usuario:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Contraseña:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Confirmar contraseña:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Correo:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Nombre:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Apellido Paterno:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: "Apellido Materno:"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(labelText: "Telefono:"),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
