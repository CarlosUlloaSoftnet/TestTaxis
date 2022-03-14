// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

List<DriversPositions> temperaturesFromJson(String str) => List<DriversPositions>.from(json.decode(str).map((x) => DriversPositions.fromJson(x)));

String temperaturesToJson(List<DriversPositions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DriversPositions {
  DriversPositions({
    required this.vehicle,
    required this.passenger,
    required this.actualLocation,
    required this.id,
    required this.v,
    required this.businessId,
    required this.deviceId,
    required this.operatorId,
    required this.status,
    required this.updatedAt,
    required this.name,
    required this.temperatureId,
  });

  Vehicle vehicle;
  Passenger passenger;
  AutoLocation actualLocation;
  String id;
  int v;
  String businessId;
  String deviceId;
  int operatorId;
  int status;
  DateTime updatedAt;
  String name;
  String temperatureId;

  factory DriversPositions.fromJson(Map<String, dynamic> json) => DriversPositions(
    vehicle: Vehicle.fromJson(json["vehicle"]),
    passenger: Passenger.fromJson(json["passenger"]),
    actualLocation: AutoLocation.fromJson(json["actualLocation"]),
    id: json["_id"],
    v: json["__v"],
    businessId: json["businessId"],
    deviceId: json["deviceId"],
    operatorId: json["operatorId"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    name: json["name"],
    temperatureId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "vehicle": vehicle.toJson(),
    "passenger": passenger.toJson(),
    "actualLocation": actualLocation.toJson(),
    "_id": id,
    "__v": v,
    "businessId": businessId,
    "deviceId": deviceId,
    "operatorId": operatorId,
    "status": status,
    "updatedAt": updatedAt.toIso8601String(),
    "name": name,
    "id": temperatureId,
  };
}

class AutoLocation {
  AutoLocation({
    required this.coordinates,
  });

  List<double> coordinates;

  factory AutoLocation.fromJson(Map<String, dynamic> json) => AutoLocation(
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class Passenger {
  Passenger({
    required this.startLocation,
    required this.destination,
  });

  StartLocation startLocation;
  AutoLocation destination;

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    startLocation: StartLocation.fromJson(json["startLocation"]),
    destination: AutoLocation.fromJson(json["destination"]),
  );

  Map<String, dynamic> toJson() => {
    "startLocation": startLocation.toJson(),
    "destination": destination.toJson(),
  };
}

class StartLocation {
  StartLocation({
    required this.coordinates,
    required this.type,
  });

  List<dynamic> coordinates;
  String type;

  factory StartLocation.fromJson(Map<String, dynamic> json) => StartLocation(
    coordinates: List<dynamic>.from(json["coordinates"].map((x) => x)),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "type": type,
  };
}

class Vehicle {
  Vehicle({
    required this.id,
    required this.plates,
    required this.description,
  });

  String id;
  String plates;
  String description;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    plates: json["plates"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plates": plates,
    "description": description,
  };
}
