import 'dart:convert';

List<MonitoringModel> monitoringModelFromJson(String str) => List<MonitoringModel>.from(json.decode(str).map((x) => MonitoringModel.fromJson(x)));

String monitoringModelToJson(List<MonitoringModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MonitoringModel {
  MonitoringModel({
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
  DateTime updatedAt;
  DateTime tgl;

  factory MonitoringModel.fromJson(Map<String, dynamic> json) => MonitoringModel(
    idTrial: json["id_trial"],
    namaLokasi: namaLokasiValues.map[json["nama_lokasi"] ?? 'FGC'],
    suhu: double.parse(json["suhu"]),
    kelembaban: double.parse(json["kelembaban"]),
    updatedAt: DateTime.parse(json["updated_at"]),
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

enum NamaLokasi { FGWC, MANGLI }

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