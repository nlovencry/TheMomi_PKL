// To parse this JSON data, do
//
//     final monitoringPerjamModel = monitoringPerjamModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<MonitoringPerjamModel> monitoringPerjamModelFromJson(String str) => List<MonitoringPerjamModel>.from(json.decode(str).map((x) => MonitoringPerjamModel.fromJson(x)));

String monitoringPerjamModelToJson(List<MonitoringPerjamModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MonitoringPerjamModel {
  MonitoringPerjamModel({
    required this.idTrial,
    required this.namaLokasi,
    required this.suhu,
    required this.kelembaban,
    required this.updatedAt,
    required this.tgl,
  });

  String idTrial;
  NamaLokasi? namaLokasi;
  double suhu;
  double kelembaban;
  String updatedAt;
  DateTime tgl;

  factory MonitoringPerjamModel.fromJson(Map<String, dynamic> json) => MonitoringPerjamModel(
    idTrial: json["id_trial"],
    namaLokasi: namaLokasiValues.map[json["nama_lokasi"] ?? 'FGC'],
    suhu: double.parse(json["suhu"]),
    kelembaban: double.parse(json["kelembaban"]),
    updatedAt: json["updated_at"],
    tgl: DateTime.parse(json["tgl"]),
  );

  Map<String, dynamic> toJson() => {
    "id_trial": idTrial,
    "nama_lokasi": namaLokasiValues.reverse[namaLokasi],
    "suhu": suhu,
    "kelembaban": kelembaban,
    "updated_at": updatedAt,
    "tgl": "${tgl.year.toString().padLeft(4, '0')}-${tgl.month.toString().padLeft(2, '0')}-${tgl.day.toString().padLeft(2, '0')}",
  };
}

enum NamaLokasi { MANGLI, FGWC }

final namaLokasiValues = EnumValues({
  "FGWC": NamaLokasi.FGWC,
  "Mangli": NamaLokasi.MANGLI
});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
