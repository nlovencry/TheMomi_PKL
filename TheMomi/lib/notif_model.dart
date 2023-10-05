// To parse this JSON data, do
//
//     final notifModel = notifModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<NotifModel> notifModelFromJson(String str) => List<NotifModel>.from(json.decode(str).map((x) => NotifModel.fromJson(x)));

String notifModelToJson(List<NotifModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotifModel {
  NotifModel({
    required this.idTrial,
    required this.suhu,
    required this.kelembaban,
    required this.keterangan,
    required this.kodeLokasi,
    required this.updatedAt,
    required this.jam,
    required this.statusNotif,
  });

  String idTrial;
  String suhu;
  String kelembaban;
  String keterangan;
  String kodeLokasi;
  DateTime updatedAt;
  String jam;
  String statusNotif;

  factory NotifModel.fromJson(Map<String, dynamic> json) => NotifModel(
    idTrial: json["id_trial"],
    suhu: json["suhu"],
    kelembaban: json["kelembaban"],
    keterangan: json["keterangan"],
    kodeLokasi: json["kode_lokasi"],
    updatedAt: DateTime.parse(json["updated_at"]),
    jam: json["jam"],
    statusNotif: json["statusNotif"],
  );

  Map<String, dynamic> toJson() => {
    "id_trial": idTrial,
    "suhu": suhu,
    "kelembaban": kelembaban,
    "keterangan": keterangan,
    "kode_lokasi": kodeLokasi,
    "updated_at": updatedAt.toIso8601String(),
    "jam": jam,
    "statusNotif": statusNotif,
  };
}
