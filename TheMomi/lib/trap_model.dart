// To parse this JSON data, do
//
//     final trapModel = trapModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TrapModel trapModelFromJson(String str) => TrapModel.fromJson(json.decode(str));

String trapModelToJson(TrapModel data) => json.encode(data.toJson());

class TrapModel {
  TrapModel({
    required this.idTrap,
    required this.namaTrap,
    required this.jumlahKomulatif,
    required this.namaLokasi,
    required this.kodeLokasi,
  });

  String idTrap;
  String namaTrap;
  String jumlahKomulatif;
  String namaLokasi;
  String kodeLokasi;

  factory TrapModel.fromJson(Map<String, dynamic> json) => TrapModel(
    idTrap: json["id_trap"],
    namaTrap: json["nama_trap"],
    jumlahKomulatif: json["jumlahKomulatif"],
    namaLokasi: json["nama_lokasi"],
    kodeLokasi: json["kode_lokasi"],
  );

  Map<String, dynamic> toJson() => {
    "id_trap": idTrap,
    "nama_trap": namaTrap,
    "jumlahKomulatif": jumlahKomulatif,
    "nama_lokasi": namaLokasi,
    "kode_lokasi": kodeLokasi,
  };
}
