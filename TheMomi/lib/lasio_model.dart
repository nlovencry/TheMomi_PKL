// To parse this JSON data, do
//
//     final lasioModel = lasioModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<LasioModel> lasioModelFromJson(String str) => List<LasioModel>.from(json.decode(str).map((x) => LasioModel.fromJson(x)));

String lasioModelToJson(List<LasioModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LasioModel {
  LasioModel({
    required this.idTrapDetail,
    required this.idTrap,
    required this.tgl,
    required this.jumlah,
    required this.image,
    required this.createdAt,
  });

  String idTrapDetail;
  String idTrap;
  DateTime tgl;
  String jumlah;
  String image;
  String createdAt;

  factory LasioModel.fromJson(Map<String, dynamic> json) => LasioModel(
    idTrapDetail: json["id_trap_detail"],
    idTrap: json["id_trap"],
    tgl: DateTime.parse(json["tgl"]),
    jumlah: json["jumlah"],
    image: json["image"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id_trap_detail": idTrapDetail,
    "id_trap": idTrap,
    "tgl": "${tgl.year.toString().padLeft(4, '0')}-${tgl.month.toString().padLeft(2, '0')}-${tgl.day.toString().padLeft(2, '0')}",
    "jumlah": jumlah,
    "image": image,
    "created_at": createdAt,
  };
}
