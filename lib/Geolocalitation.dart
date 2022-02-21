// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.status,
    required this.data,
  });

  String status;
  Data data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.locations,
  });

  List<LocationDataList> locations;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    locations: List<LocationDataList>.from(json["locations"].map((x) => LocationDataList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
  };
}

class LocationDataList {
  LocationDataList({
    this.id,
    this.businessId,
    required this.destination,
    this.deviceId,
    this.locationId,
    required this.origin,
    required this.passenger,
    required this.position,
    this.status,
    this.timestamp,
  });

  String? id;
  int? businessId;
  Destination destination;
  String? deviceId;
  String? locationId;
  Destination origin;
  Destination passenger;
  Position position;
  int? status;
  int? timestamp;

  factory LocationDataList.fromJson(Map<String, dynamic> json) => LocationDataList(
    id: json["_id"],
    businessId: json["businessId"],
    destination: Destination.fromJson(json["destination"]),
    deviceId: json["deviceId"],
    locationId: json["id"],
    origin: Destination.fromJson(json["origin"]),
    passenger: Destination.fromJson(json["passenger"]),
    position: Position.fromJson(json["position"]),
    status: json["status"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "businessId": businessId,
    "destination": destination.toJson(),
    "deviceId": deviceId,
    "id": locationId,
    "origin": origin.toJson(),
    "passenger": passenger.toJson(),
    "position": position.toJson(),
    "status": status,
    "timestamp": timestamp,
  };
}

class Destination {
  Destination();

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Position {
  Position({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}
