import 'dart:io';
import 'dart:ui';

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
  var textUser = "";
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
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/fondoTaxi.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.white.withOpacity(0.0)),
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
                      EdgeInsets.symmetric(horizontal: 25.h, vertical: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 25.h,
                      ),
                      TextFormField(
                        autofillHints: const [AutofillHints.username],
                        style:
                            const TextStyle(overflow: TextOverflow.ellipsis),
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
                            setState(() {
                              textUser = text;
                            });
                            _formKey.currentState?.validate();
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white24,
                          labelText: "Usuario:",
                          suffixIcon: textUser.isNotEmpty
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
                        height: 25.h,
                      ),
                      TextFormField(

                        autofillHints: const [AutofillHints.password],
                        style:
                            const TextStyle(overflow: TextOverflow.ellipsis),
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
                            fillColor: Colors.white24,
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
                        padding: EdgeInsets.only(top: 25.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40.h,
                          child: ElevatedButton(
                            child: const Text("Aceptar"),
                            style: ElevatedButton.styleFrom(shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),),
                            // style: ElevatedButton.styleFrom(
                            //     primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              Navigator.of(context).pop();
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
                          Text('¿No estas resgistrado?',style: TextStyle(fontSize: 12.w)),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                return;
                              }
                              Navigator.pushNamed(context, "/Register");
                            },
                            child: Text("Registrarse", style: TextStyle(fontSize: 15.w, fontWeight: FontWeight.bold)),
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
