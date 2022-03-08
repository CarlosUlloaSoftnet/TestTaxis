import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  var _obscureText = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(
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
                elevation: 150,
                color: Colors.white54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.all(20.h),
                child: Padding(
                  padding:
                       EdgeInsets.symmetric(horizontal: 35.h, vertical: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        autofillHints: const [AutofillHints.username],
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                        controller: _userController,
                        maxLength: 30,
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su usuario';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          if (text.length > 1) {
                            _formKey.currentState?.validate();
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          // fillColor: Colors.grey[600],
                          labelText: "Usuario:",
                          suffixIcon: _userController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: () {
                                    _userController.clear();
                                  })
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      TextFormField(
                        autofillHints: const [AutofillHints.password],
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                        controller: _passController,
                        obscureText: _obscureText,
                        maxLength: 10,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          if (text.length > 1) {
                            _formKey.currentState?.validate();
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            labelText: "Contraseña:",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40.h,
                          child: ElevatedButton(
                            child: const Text("Aceptar"),
                            // style: ElevatedButton.styleFrom(
                            //     primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              Navigator.pushNamed(context, "/MapHome");
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('¿No estas resgistrado?'),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                return;
                              }
                              Navigator.pushNamed(context, "/Register");
                            },
                            child: const Text("Registrarse"),
                            style: TextButton.styleFrom(
                              primary: Colors.deepOrange,
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
      ),
    );
  }
}
