import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:test_project/widgets/loading.dart';

import '../helpers/style.dart';
import '../providers/app_state.dart';

class PaymentMethodSelectionWidget extends StatefulWidget {
  const PaymentMethodSelectionWidget({Key? key}) : super(key: key);

  @override
  State<PaymentMethodSelectionWidget> createState() =>
      _PaymentMethodSelectionWidgetState();
}

class _PaymentMethodSelectionWidgetState
    extends State<PaymentMethodSelectionWidget> {
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    Color? colorCard = Colors.grey[300];
    KeyboardVisibilityController().onChange.listen((isVisible) {
      if (isVisible) {
      } else {
        panelController.collapse();
        appState.visibleFAB = true;
      }
    });
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: SlidingUpPanelWidget(
        dragEnd: (details) {
          switch (panelController.status) {
            case SlidingUpPanelStatus.expanded:
              appState.setVisibleFAB(false);
              break;
            case SlidingUpPanelStatus.collapsed:
              appState.setPaddingFAB(160.h);
              appState.setVisibleFAB(true);
              FocusScope.of(context).unfocus();
              break;
            case SlidingUpPanelStatus.anchored:
              appState.setPaddingFAB(260.h);
              appState.setVisibleFAB(true);
              break;
            case SlidingUpPanelStatus.hidden:
              // TODO: Handle this case.
              break;
            case SlidingUpPanelStatus.dragging:
              // TODO: Handle this case.
              break;
          }
        },
        enableOnTap: false,
        controlHeight: 210.0.h,
        anchor: 0.4,
        panelController: panelController,
        child: Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w),
                  topRight: Radius.circular(20.h)),
              boxShadow: [
                BoxShadow(
                    color: Colors.orange.withOpacity(.8),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                // controller: myscrollController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Icon(
                    Icons.remove,
                    size: 20.h,
                    color: grey,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 80.h,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Card(
                            elevation: 150,
                            color: colorCard,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.all(5.h),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext contextDialog) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: SizedBox(
                                          height: 180.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Viaje",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 22.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                "Tipo de vehículo: ${appState.ratesList[0].type}",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // SizedBox(
                                              //   height: 10.h,
                                              // ),
                                              // Text(
                                              //   "Numero de pasajeros: 4",
                                              //   style: TextStyle(
                                              //       color: Colors.orange,
                                              //       fontWeight:
                                              //           FontWeight.bold),
                                              // ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Tarifa estimada: ",
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "\$${appState.ratesList[0].estimate}",
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 22.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.h,
                                                          right: 8.h),
                                                      child: SizedBox(
                                                        height: 35.h,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                contextDialog);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .deepOrange,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Cancelar",
                                                            style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.h,
                                                          right: 8.h),
                                                      child: SizedBox(
                                                        height: 35.h,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                contextDialog);
                                                            confirm();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.orange,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Confirmar viaje",
                                                            style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.h, vertical: 5.w),
                                  child: Row(
                                    children: [
                                      const Image(
                                        image: NetworkImage(
                                            'https://cdn0.iconfinder.com/data/icons/isometric-city-basic-transport/480/car-taxi-front-01-512.png'),
                                        height: 55,
                                        width: 85,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.w, right: 15.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${appState.ratesList[0].type}",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.deepOrange),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                                "\$${appState.ratesList[0].estimate}",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.deepOrange,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                      // ListTile(
                                      //   title: const Text('Sedan'),
                                      //   subtitle: Text("\$${appState.ridePrice}"),
                                      // )
                                    ],
                                  )),
                            )),
                        Card(
                            elevation: 150,
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.all(5.h),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext contextDialog) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: SizedBox(
                                          height: 180.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Viaje",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 22.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                "Tipo de vehículo: ${appState.ratesList[1].type}",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // SizedBox(
                                              //   height: 10.h,
                                              // ),
                                              // Text(
                                              //   "Numero de pasajeros: 6",
                                              //   style: TextStyle(
                                              //       color: Colors.orange,
                                              //       fontWeight:
                                              //       FontWeight.bold),
                                              // ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Tarifa estimada: ",
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "\$${appState.ratesList[1].estimate}",
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 22.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.h,
                                                          right: 8.h),
                                                      child: SizedBox(
                                                        height: 35.h,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                contextDialog);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .deepOrange,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Cancelar",
                                                            style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.h,
                                                          right: 8.h),
                                                      child: SizedBox(
                                                        height: 35.h,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                contextDialog);
                                                            confirm();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.orange,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Confirmar viaje",
                                                            style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.h, vertical: 5.w),
                                  child: Row(
                                    children: [
                                      const Image(
                                        image: NetworkImage(
                                            'https://cdn0.iconfinder.com/data/icons/isometric-city-basic-transport/480/car-taxi-front-01-512.png'),
                                        height: 55,
                                        width: 85,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.w, right: 15.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${appState.ratesList[1].type}",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.deepOrange),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                                "\$${appState.ratesList[1].estimate}",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.deepOrange,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                      // ListTile(
                                      //   title: const Text('Sedan'),
                                      //   subtitle: Text("\$${appState.ridePrice}"),
                                      // )
                                    ],
                                  )),
                            )),
                        Card(
                            elevation: 150,
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.all(5.h),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext contextDialog) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: SizedBox(
                                          height: 180.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Viaje",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 22.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                "Tipo de vehículo: ${appState.ratesList[2].type}",
                                                style: const TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // SizedBox(
                                              //   height: 10.h,
                                              // ),
                                              // Text(
                                              //   "Numero de pasajeros: 8",
                                              //   style: TextStyle(
                                              //       color: Colors.orange,
                                              //       fontWeight:
                                              //       FontWeight.bold),
                                              // ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Tarifa estimada: ",
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "\$${appState.ratesList[2].estimate}",
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 22.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.h,
                                                          right: 8.h),
                                                      child: SizedBox(
                                                        height: 35.h,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                contextDialog);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .deepOrange,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Cancelar",
                                                            style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.h,
                                                          right: 8.h),
                                                      child: SizedBox(
                                                        height: 35.h,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                contextDialog);
                                                            confirm();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.orange,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Confirmar viaje",
                                                            style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.h, vertical: 5.w),
                                  child: Row(
                                    children: [
                                      const Image(
                                        image: NetworkImage(
                                            'https://cdn0.iconfinder.com/data/icons/isometric-city-basic-transport/480/car-taxi-front-01-512.png'),
                                        height: 55,
                                        width: 85,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.w, right: 15.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${appState.ratesList[2].type}",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.deepOrange),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                                "\$${appState.ratesList[2].estimate}",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.deepOrange,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                      // ListTile(
                                      //   title: const Text('Sedan'),
                                      //   subtitle: Text("\$${appState.ridePrice}"),
                                      // )
                                    ],
                                  )),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  const Divider(),
                  Row(
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/dollar.png'),
                        height: 15,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Efectivo",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20.h,
                        color: grey,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              cancel(appState);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Cancelar viaje",
                              style: TextStyle(color: white, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void cancel(AppStateProvider appState) {
    appState.setPaddingFAB(160.h);
    // await appState.sendRequest();
    appState.updateDestination(destination: "");
    appState.changePickupLocationAddress(address: "");
    appState.changeWidgetShowed(showWidget: Show.DESTINATION_SELECTION);
  }

  void confirm() {
    panelController.hide();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Loading(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Buscando un conductor",
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    LinearPercentIndicator(
                      lineHeight: 4,
                      animation: true,
                      animationDuration: 100000,
                      percent: 1,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      progressColor: Colors.deepOrange,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              panelController.anchor();
                              /*appState
                                                              .cancelRequest();*/
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.deepOrange),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Cancelar solicitud",
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 15.sp),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
