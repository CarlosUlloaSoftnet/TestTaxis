import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/style.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: white,
        child: Text("Carga",style: TextStyle(color: Colors.deepOrange),
        )
    );
  }
}