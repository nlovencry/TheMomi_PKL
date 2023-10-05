// To parse this JSON data, do
//
//     final sensorModel = sensorModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SensorModel sensorModelFromJson(String str) => SensorModel.fromJson(json.decode(str));

String sensorModelToJson(SensorModel data) => json.encode(data.toJson());

class SensorModel {
  SensorModel({
    required this.kodeLokasi,
    required this.banyakTrap,
    required this.jumlahKomulatif,
    required this.rataRata,
    required this.target,
    required this.statusGudang,
  });

  String kodeLokasi;
  String banyakTrap;
  String jumlahKomulatif;
  double rataRata;
  String target;
  String statusGudang;

  factory SensorModel.fromJson(Map<String, dynamic> json) => SensorModel(
    kodeLokasi: json["kodeLokasi"],
    banyakTrap: json["banyakTrap"],
    jumlahKomulatif: json["jumlahKomulatif"],
    rataRata: double.parse(json["rataRata"]),
    target: json["target"],
    statusGudang: json["statusGudang"],
  );

  Map<String, dynamic> toJson() => {
    "kodeLokasi": kodeLokasi,
    "banyakTrap": banyakTrap,
    "jumlahKomulatif": jumlahKomulatif,
    "rataRata": rataRata,
    "target": target,
    "statusGudang": statusGudang,
  };
}
