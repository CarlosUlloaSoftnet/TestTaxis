import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/helpers/constants.dart';
import '../helpers/style.dart';
import '../providers/app_state.dart';

class DestinationWidget extends StatefulWidget {
  const DestinationWidget({Key? key}) : super(key: key);

  @override
  DestinationSelectionWidget createState() => DestinationSelectionWidget();
}

class DestinationSelectionWidget extends State<DestinationWidget> {
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late DetailsResult detailsResult;

  @override
  void initState() {
    googlePlace = GooglePlace(GOOGLE_MAPS_API_KEY);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
     KeyboardVisibilityController().onChange.listen((isVisible) {
      if(isVisible){

      }else{
        panelController.collapse();
        appState.visibleFAB = true;
      }
    });
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: SlidingUpPanelWidget(
          dragEnd: (details){
            switch(panelController.status){

              case SlidingUpPanelStatus.expanded:
                appState.setVisibleFAB(false);
                break;
              case SlidingUpPanelStatus.collapsed:
                appState.setPaddingFAB(130.h);
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
          controlHeight: 120.0.h,
          anchor: 0.4,
          panelController: panelController,
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.withOpacity(.8),
                      offset: const Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              // controller: myscrollController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Icon(
                  Icons.remove,
                  size: 20.h,
                  color: grey,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    onTap: () async {
                      panelController.expand();
                      appState.visibleFAB = false;
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else if (predictions.isNotEmpty && mounted) {
                        setState(() {
                          predictions.clear();
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    controller: appState.destinationController,
                    style: TextStyle(fontSize: 18.sp, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: "A donde vamos?",
                      hintStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: ListView.builder(
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.pin_drop_outlined,
                                color: Colors.deepOrange,
                              ),
                            ),
                            title: Text(predictions[index].description!, style: const TextStyle(color: Colors.deepOrange),),
                            onTap: () async {
                              debugPrint(predictions[index].placeId);
                              if (predictions[index] != null) {
                                var result = await googlePlace.details
                                    .get(predictions[index].placeId!);
                                if (result != null &&
                                    result.result != null &&
                                    mounted) {
                                  if (result.result!.geometry != null) {
                                    double lat =
                                        result.result!.geometry!.location!.lat!;
                                    double lng =
                                        result.result!.geometry!.location!.lng!;
                                    appState.changeRequestedOrigin(
                                        reqDestination: predictions[index].description, lat: lat, lng: lng);
                                    appState.updateDestination(
                                        destination:
                                            predictions[index].description);
                                    LatLng coordinates = LatLng(lat, lng);
                                    appState.setDestination(
                                        coordinates: coordinates);
                                    // appState.addPickupMarker(coordinates);

                                    appState.changeWidgetShowed(
                                        showWidget: Show.PICKUP_SELECTION);
                                    appState.setPaddingFAB(260.h);
                                  }
                                }
                              }
                              panelController.collapse();
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
