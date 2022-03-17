// To parse this JSON data, do
//
//     final rates = ratesFromJson(jsonString);

import 'dart:convert';

Rates ratesFromJson(String str) => Rates.fromJson(json.decode(str));

String ratesToJson(Rates data) => json.encode(data.toJson());

class Rates {
  Rates({
    required this.status,
    required this.data,
  });

  String status;
  List<Datum> data;

  factory Rates.fromJson(Map<String, dynamic> json) => Rates(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.type,
    required this.estimate,
  });

  String type;
  String estimate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: json["type"],
    estimate: json["estimate"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "estimate": estimate,
  };
}
