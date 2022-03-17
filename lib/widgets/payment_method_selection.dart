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
        controlHeight: 200.0.h,
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
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.all(5.h),
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
                                            "Sedan",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.deepOrange),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text("\$${appState.ridePrice}",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )
                                    // ListTile(
                                    //   title: const Text('Sedan'),
                                    //   subtitle: Text("\$${appState.ridePrice}"),
                                    // )
                                  ],
                                ))),
                        Card(
                            elevation: 150,
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.all(5.h),
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
                                            "SUV",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.deepOrange),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                              "\$${(appState.ridePrice + 60).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )
                                    // ListTile(
                                    //   title: const Text('Sedan'),
                                    //   subtitle: Text("\$${appState.ridePrice}"),
                                    // )
                                  ],
                                ))),
                        Card(
                            elevation: 150,
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.all(5.h),
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
                                            "Van",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.deepOrange),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                              "\$${(appState.ridePrice + 100).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )
                                    // ListTile(
                                    //   title: const Text('Sedan'),
                                    //   subtitle: Text("\$${appState.ridePrice}"),
                                    // )
                                  ],
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15.0.w,
                        right: 15.0.w,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          panelController.hide();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0)), //this right here
                                  child: SizedBox(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Loading(),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.2),
                                            progressColor: Colors.deepOrange,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    panelController.anchor();
                                                    /*appState
                                                              .cancelRequest();*/
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(
                                                          color:
                                                              Colors.deepOrange)),
                                                  child: Text(
                                                    "Cancelar solicitud",
                                                    style: TextStyle(
                                                        color: Colors.deepOrange,
                                                        fontSize: 15.sp),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        child: Text(
                          "Confirmar viaje",
                          style: TextStyle(color: white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
