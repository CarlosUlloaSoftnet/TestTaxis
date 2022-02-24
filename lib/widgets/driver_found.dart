import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/style.dart';
import '../providers/app_state.dart';
import '../services/calls_sms.dart';

class DriverFoundWidget extends StatelessWidget {
  // final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.05,
        maxChildSize: 0.8,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(color: white,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20),
//                            topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(.8),
                      offset: Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              controller: myscrollController,
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: appState.driverArrived == false ? Text(
                          'Your ride arrives in appState.routeModel.timeNeeded.text',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,),
                        ) : Text(
                          'Your ride has arrived',
                          style: TextStyle(fontSize: 12, color: green, fontWeight: FontWeight.w500),
                        )
                    ),
                  ],
                ),
                Divider(),
                ListTile(
                  leading: Container(
                    child:appState.driverModel?.phone  == null ? CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person_outline, size: 25,),
                    ) : CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage("http://www.toyocosta.com/blog/wp-content/uploads/2014/04/www.sienteamerica.com_.jpg"),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "NOMBRE DEL CONDUCTOR" + "\n",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: appState.driverModel.car,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                          ], style: TextStyle(color: black))),
                    ],
                  ),
                  subtitle: RaisedButton(
                      color: Colors.grey.withOpacity(0.5),
                      onPressed: null,
                      child: Text("Marca del vehiculo",
                        style: TextStyle(color: white),
                      )),
                  trailing: Container(
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                        onPressed: () {
                          // _service.call(appState.driverModel.phone);
                        },
                        icon: Icon(Icons.call),
                      )),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text("Ride details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 100,
                      width: 10,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Container(
                              height: 45,
                              width: 2,
                              color: primary,
                            ),
                          ),
                          Icon(Icons.flag),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nPick up location \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text: "25th avenue, flutter street \n\n\n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16)),
                          TextSpan(
                              text: "Destination \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text: "25th avenue, flutter street \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16)),
                        ], style: TextStyle(color: black))),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text("Ride price",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text("\$100",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: RaisedButton(
                    onPressed: () {},
                    color: red,
                    child: Text("Cancel Ride",
                      style: TextStyle(color: white)
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
