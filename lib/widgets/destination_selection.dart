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
    /* KeyboardVisibilityController().onChange.listen((isVisible) {
      if(isVisible){
        appState.setSize(0.50, 0.45);
      }else{
        panelController.collapse();
      }
    });*/
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: SlidingUpPanelWidget(
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
                const Icon(
                  Icons.remove,
                  size: 40,
                  color: grey,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    onTap: () async {
                      panelController.expand();
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      /*Prediction? p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: GOOGLE_MAPS_API_KEY,
                          mode: Mode.overlay, // Mode.fullscreen
                          // language: "pt",
                          components: [
                            new Component(Component.country,
                                preferences.getString(COUNTRY))
                          ]);*/
                      // PlacesDetailsResponse detail =
                      // await places.getDetailsByPlaceId(p?.placeId);
                      /* double lat = detail.result.geometry?.location.lat;
                      double lng = detail.result.geometry.location.lng;
                      appState.changeRequestedDestination(
                          reqDestination: p.description, lat: lat, lng: lng);
                      appState.updateDestination(destination: p.description);
                      LatLng coordinates = LatLng(lat, lng);
                      // appState.setDestination(coordinates: coordinates);
                      appState.addPickupMarker(appState.center!);

                      appState.changeWidgetShowed(
                          showWidget: Show.PICKUP_SELECTION);*/
                      // appState.sendRequest(coordinates: coordinates);
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else if (predictions.isNotEmpty && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    controller: appState.destinationController,
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
                      /*icon: Container(
                        margin: EdgeInsets.only(left: 20, bottom: 15),
                        width: 10,
                        height: 10,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.orange,
                        ),
                      ),*/
                      hintText: "A donde vamos?",
                      hintStyle: const TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
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
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(predictions[index].description!),
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
                                    // appState.changeRequestedDestination(
                                    //     reqDestination: p.description, lat: lat, lng: lng);
                                    appState.updateDestination(
                                        destination:
                                            predictions[index].description);
                                    LatLng coordinates = LatLng(lat, lng);
                                    appState.setDestination(
                                        coordinates: coordinates);
                                    appState.addPickupMarker(appState.center!);

                                    appState.changeWidgetShowed(
                                        showWidget: Show.PICKUP_SELECTION);
                                  }
                                }
                              }
                              panelController.collapse();
                            },
                          );
                        }),
                  ),
                ),
                /*ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange[300],
                    child: const Icon(
                      Icons.home,
                      color: white,
                    ),
                  ),
                  title: const Text("Casa"),
                  subtitle: Text("Mariano de abasolo"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange[300],
                    child: const Icon(
                      Icons.work,
                      color: white,
                    ),
                  ),
                  title: const Text("Trabajo"),
                  subtitle: const Text("Sayula 215"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.18),
                    child: const Icon(
                      Icons.history,
                      color: primary,
                    ),
                  ),
                  title: const Text("Dirección recinente"),
                  subtitle: const Text("Av. Félix U. Gómez"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.18),
                    child: const Icon(
                      Icons.history,
                      color: primary,
                    ),
                  ),
                  title: const Text("Dirección recinente"),
                  subtitle: const Text("Av. Benito Juárez"),
                ),*/
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
