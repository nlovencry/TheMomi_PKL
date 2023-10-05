import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_momi/detail_sensor_minute_page.dart';
import 'package:the_momi/monitoring_model.dart';
import 'package:http/http.dart' as http;
import 'package:the_momi/monitoring_perjam_model.dart';
import 'detail_sensor_minute_page.dart' as dsm;
import 'myapp.dart';
import 'notif_page.dart';

var drawerLokasi;
var namaSensor;
var jam;

class SensorList {
  int? id;
  String? suhu;
  String? kelembaban;
  String? updated_at;
  String? tgl;

  SensorList({this.id, this.suhu, this.kelembaban, this.updated_at, this.tgl});

  SensorList.fromJson(Map json)
      : id = int.parse(json['id_trial']),
        suhu = json['suhu'].toString(),
        kelembaban = json['kelembaban'].toString(),
        updated_at = json['updated_at'].toString(),
        tgl = json['tgl'].toString();
}

class DetailSensorPage extends StatefulWidget {
  const DetailSensorPage({Key? key}) : super(key: key);

  @override
  State<DetailSensorPage> createState() => _DetailSensorPageState();
}

class _DetailSensorPageState extends State<DetailSensorPage> {
  List<SensorList> listSensor = [];
  var locUser;

  Future<List<MonitoringPerjamModel>> getDataPerJam() async {
    var locUser = drawerLokasi;
    var url = "https://mio.ptmdr.co.id/Themomi/getDataPerSensor";
    final response =
        await http.post(Uri.parse(url), body: {'locUser': locUser});
    var listSensor = monitoringPerjamModelFromJson(response.body);
    return listSensor;
  }

  void getListSensor() async {
    /// Testing Scroll View
    try {
      String Apiurl = "https://mio.ptmdr.co.id/Themomi/getDataPerSensor";
      final response =
          await http.post(Uri.parse(Apiurl), body: {'locUser': drawerLokasi});
      print("getListSensor");
      // print(locUser);
      if (response.statusCode == 200) {
        final dataDecode = await jsonDecode(response.body);
        // print("Data Found");
        setState(() {
          for (var row in dataDecode) {
            listSensor.add(SensorList.fromJson(row));
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  String _formattingDate(String rawDate) {
    var dateFormat = DateFormat('d MMM yyyy');
    var date = DateTime.parse(rawDate);
    return dateFormat.format(date);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListSensor();
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> _rowlist = [];
    var top = listSensor.length;
    for(var a=0;a<top;a++)
    {
      var item = listSensor[a];
      _rowlist.add(DataRow(
        cells: <DataCell>[
          DataCell(Text(_formattingDate("${item.tgl}")), onTap: () {
            setState(() {
              dsm.drawerLokasi = drawerLokasi;
              dsm.jam = item.updated_at;
              dsm.tanggal = item.tgl;
            });
            Navigator.pushNamed(context, '/detailsensorpermenit');
          }),
          DataCell(Text("${item.updated_at}.00")),
          DataCell(Text("${item.suhu}°C")),
          DataCell(Text("${item.kelembaban}%")),
          DataCell(
            InkWell(
              onTap: () {
                setState(() {
                  dsm.namaSensor = namaSensor;
                  dsm.drawerLokasi = drawerLokasi;
                  dsm.jam = item.updated_at;
                  dsm.tanggal = item.tgl;
                });
                Navigator.pushNamed(context, '/detailsensorpermenit');
              },
              splashColor: Colors.blue,
              child: Icon(
                Icons.library_books_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {
            getDataPerJam();
          });
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Gudang " + drawerLokasi,
                    style: TextStyle(
                      color: Color(0xFFE8CB79),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 130),
                  Text(
                    namaSensor,
                    style: TextStyle(
                      color: Color(0xFFE8CB79),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FutureBuilder<List<MonitoringPerjamModel>>(
                          future: getDataPerJam(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return DataTable(
                                decoration:
                                    BoxDecoration(color: Color(0xFFE8CB79),
                                    borderRadius: BorderRadius.circular(15),
                                    ),
                                columns: <DataColumn>[
                                  DataColumn(label: Text("Date")),
                                  DataColumn(label: Text("Time")),
                                  DataColumn(label: Text("Temp")),
                                  DataColumn(label: Text("Humd")),
                                  DataColumn(label: Text("Detail")),
                                ],
                                rows: _rowlist);
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
