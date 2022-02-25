import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/style.dart';
import '../providers/app_state.dart';
import '../services/calls_sms.dart';

class DriverFoundWidget extends StatelessWidget {
  const DriverFoundWidget({Key? key}) : super(key: key);

  // final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.17,
        maxChildSize: 0.55,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(color: white,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20),
//                            topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(.8),
                      offset: const Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              controller: myscrollController,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: appState.driverArrived == false ? const Text(
                          'Llegara en 30 min',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,),
                        ) : const Text(
                          'Your ride has arrived',
                          style: TextStyle(fontSize: 12, color: green, fontWeight: FontWeight.w500),
                        )
                    ),
                  ],
                ),
                Divider(),
                ListTile(
                  leading: Container(
                    // child:appState.driverModel?.phone  == null ? CircleAvatar(
                    // child:appState.driverModel?.phone  == null ? CircleAvatar(
                    //   radius: 30,
                    //   child: Icon(Icons.person_outline, size: 25,),
                    // ) :
                    child:const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage("http://www.toyocosta.com/blog/wp-content/uploads/2014/04/www.sienteamerica.com_.jpg"),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text: "Carlos Ulloa" + "\n",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "Mustang GT",
                                // text: appState.driverModel.car,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                          ], style: TextStyle(color: black))),
                    ],
                  ),
                  subtitle: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey.withOpacity(0.5)),
                      onPressed: null,
                      child: const Text("Ford",
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
                        icon: const Icon(Icons.call),
                      )),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Detalle",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 100,
                      width: 10,
                      child: Column(
                        children: [
                          const Icon(
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
                    const SizedBox(
                      width: 30,
                    ),
                    RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "\nUbicación del conductor \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text: "Av. Félix U. Gómez \n\n\n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16)),
                          TextSpan(
                              text: "Destino \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text: "Av. Benito Juárez \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16)),
                        ], style: TextStyle(color: black))),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Total del viaje",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("\$100",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: red, ),
                    child: Text("Cancelar viaje",
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
