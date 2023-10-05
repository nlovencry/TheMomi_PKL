import 'dart:async';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_momi/edit_alat_page.dart';
import 'package:the_momi/monitoring_model.dart';
import 'package:the_momi/notif_model.dart';
import 'package:intl/intl.dart';
import 'package:cron/cron.dart';
import 'common_function.dart';
import 'detail_sensor_page.dart' as ds;
import 'notif_page.dart';
import 'package:the_momi/trap_page.dart' as td;

int id = 0;
var drawerLokasi;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CommonFunction cf;
  late double suhu;
  late double kelembaban;
  late double suhu_atas;
  late double suhu_bawah;
  late double kelembaban_atas;
  late double kelembaban_bawah;
  late String lokasi;
  late double statusSuhu;
  late double statusKelembaban;
  late String mikro;
  var txtNotif;
  var txtLabel;
  var idTxtLabel;
  var namaSensor = "Sensor 1";
  var time;
  var tgl;
  late double id_trial;
  var statusNotif;
  var keterangan;

  var date = DateTime.now();

  Map<DateTime, double> lineSuhu = Map<DateTime, double>();
  Map<DateTime, double> lineKelembaban = Map<DateTime, double>();

  String _formattingDate(String rawDate) {
    var dateFormat = DateFormat('d MMM yyyy HH:mm');
    var date = DateTime.parse(rawDate);
    return dateFormat.format(date);
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<MonitoringModel>> getData() async {
    if (drawerLokasi == null) {
      setState(() {
        drawerLokasi = "FGC";
        time = "";
        tgl = "";
      });
    }
    var locUser = drawerLokasi;
    var url = "https://mio.ptmdr.co.id/Themomi/getDataPerSensorPerMinute";
    final response = await http.post(Uri.parse(url),
        body: {'locUser': locUser, 'time': time, 'tgl': tgl});
    var listSensor = monitoringModelFromJson(response.body);
    return listSensor;
  }

  cronScheduler() async {
    final cron = Cron();
    try {
      lineSuhu.clear();
      lineKelembaban.clear();
      cron.schedule(Schedule.parse('*	*	*	*	*	'), () {
        setState(() {
          getData();
          // cekSensor();
          getNotification();
        });
      });

      await Future.delayed(Duration(seconds: 60));
      // await cron.close();
    } on ScheduleParseException {
      // "ScheduleParseException" is thrown if cron parsing is failed.
      print("cron stopped");
      // await cron.close();
    }
  }

  void showShortToast() {
    Fluttertoast.showToast(
        msg: "Data telah ditampilkan",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  void getNotification() {
    var url = "http://10.10.10.100/api/getNotification.php";
    http.post(Uri.parse(url));
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            icon: "icon",
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    if (idTxtLabel == 1) {
      txtLabel = "Peringatan suhu pada " + lokasi;
    } else if (idTxtLabel == 2) {
      txtLabel = "Peringatan kelembaban pada " + lokasi;
    } else if (idTxtLabel == 3) {
      txtLabel = "Peringatan suhu dan kelembaban pada " + lokasi;
    } else {
      txtLabel = "The Momi";
    }
    await flutterLocalNotificationsPlugin
        .show(id++, txtLabel, txtNotif, notificationDetails, payload: 'item x');
  }

  void cekSensor() async {
    var url = "http://10.10.10.100/api/showNotification.php";
    final response = await http.post(Uri.parse(url), body: {'locUser': 'HQ'});
    var jsondata = notifModelFromJson(response.body);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String idTrialOld = pref.getString('idNotifTrial') ?? "0";
    String idTrialNew = jsondata[0].idTrial;
    if (int.parse(idTrialOld) < int.parse(idTrialNew)) {
      setState(() {
        lokasi = jsondata[0].kodeLokasi;
        idTxtLabel = 1;
        txtNotif = jsondata[0].keterangan;
        _showNotification();
        pref.setString('idNotifTrial', idTrialNew);
      });
    }
  }

  showAlertLogout(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Keluar",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFFE8CB79),
      title: Text("Keluar"),
      content:
      Text("Apakah anda yakin ingin keluar?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    cf = CommonFunction();
    super.initState();
    getData();
    cronScheduler();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Key _refreshKey = UniqueKey();

    return Scaffold(
      key: scaffoldKey,
      //Mulai AppBar
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        // Mulai Leading
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Color(0xFFE8CB79),
          onPressed: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
              //close drawer, if drawer is open
            } else {
              scaffoldKey.currentState!.openDrawer();
              //open drawer, if drawer is closed
            }
          },
        ),
        // Selesai Leading
        // Mulai title
        title: Text(
          'THE MOMI',
          style: TextStyle(
            color: Color(0xFFE8CB79),
          ),
        ),
        // Selesai Title
        centerTitle: false,
        elevation: 0,
        // Mulai Actions
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                // DetailPage adalah halaman yang dituju
                MaterialPageRoute(
                  builder: (context) => NotifPage(),
                ),
              );
            },
            child: Icon(
              Icons.notifications_none,
              size: 35,
              color: Color(0xFFE8CB79),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: PopupMenuButton(
                color: Color(0xFF000000),
                // add icon, by default "3 dot" icon
                icon: Icon(
                  Icons.account_circle,
                  size: 40,
                  color: Color(0xFFE8CB79),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        "Username",
                        style: TextStyle(
                          color: Color(0xFFE8CB79),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: InkWell(
                        child: Text(
                          "Keluar",
                          style: TextStyle(
                            color: Color(0xFFE8CB79),
                          ),
                        ),
                        onTap: (){
                          showAlertLogout(context);
                        },
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    print("Username menu is selected.");
                  } else if (value == 1) {
                    print("Logout menu is selected.");
                  }
                }),
          ),
        ],
        // Selesai Actions
      ),
      // Selesai AppBar
      // Mulai Drawer
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Color(0xFFE8CB79),
            child: ListView(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Text(
                      "THE MOMI",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ExpansionTile(
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      title: Text(
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        "Monitoring Suhu",
                      ),
                      leading: Icon(
                        Icons.thermostat,
                        color: Colors.black,
                        size: 35,
                      ),
                      //add icon
                      childrenPadding: EdgeInsets.only(left: 60),
                      //children padding
                      children: [
                        ExpansionTile(
                          textColor: Colors.black,
                          iconColor: Colors.black,

                          title: Text(
                            "Gudang FGW",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //add icon
                          childrenPadding: EdgeInsets.only(left: 30),
                          children: [
                            // ListTile(
                            //   title: Text("Gudang GRN"),
                            //   onTap: () {
                            //   },
                            // ),
                            // ListTile(
                            //   title: Text("Gudang FGWB"),
                            //   onTap: () {
                            //     //action on press
                            //   },
                            // ),
                            ListTile(
                              title: Text("Gudang FGWC"),
                              onTap: () {
                                setState(() {
                                  drawerLokasi = "FGC";
                                  lineSuhu.clear();
                                  lineKelembaban.clear();
                                  getData();
                                });
                                showShortToast();
                                //action on press
                              },
                            ),
                            // ListTile(
                            //   title: Text("Gudang Miring"),
                            //   onTap: () {
                            //     setState(() {
                            //       drawerLokasi = "FGC";
                            //       lineSuhu.clear();
                            //       lineKelembaban.clear();
                            //       getData();
                            //     });
                            //     showShortToast();
                            //     //action on press
                            //   },
                            // ),
                          ],
                        ),
                        ExpansionTile(
                          textColor: Colors.black,
                          iconColor: Colors.black,

                          title: Text(
                            "Gudang Mangli",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //add icon
                          childrenPadding: EdgeInsets.only(left: 30),
                          children: [
                            ListTile(
                              title: Text("Gudang Tengah"),
                              onTap: () {
                                setState(() {
                                  drawerLokasi = "MGL";
                                  lineSuhu.clear();
                                  lineKelembaban.clear();
                                  getData();
                                });
                                showShortToast();
                                //action on press
                              },
                            ),
                            // ListTile(
                            //   title: Text("Gudang Air Biru"),
                            //   onTap: () {
                            //     //action on press
                            //   },
                            // ),
                          ],
                        ),
                        //more child menu
                      ],
                    ),
                    ExpansionTile(
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      title: Text(
                        "Lasio Trap",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Icon(
                        Icons.bug_report,
                        color: Colors.black,
                        size: 35,
                      ),
                      //add icon
                      childrenPadding: EdgeInsets.only(left: 60),
                      //children padding
                      children: [
                        ExpansionTile(
                          textColor: Colors.black,
                          iconColor: Colors.black,
                          title: Text(
                            "Gudang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //add icon
                          childrenPadding: EdgeInsets.only(left: 30),
                          children: [
                            ListTile(
                              title: Text("Gudang GRN"),
                              onTap: () {
                                setState(() {
                                  drawerLokasi = "GRN";
                                  td.drawerLokasi = drawerLokasi;
                                });
                                Navigator.pushNamed(context, '/traplasio');
                              },
                            ),
                            ListTile(
                              title: Text("Gudang FGWB"),
                              onTap: () {
                                setState(() {
                                  drawerLokasi = "FGB";
                                  td.drawerLokasi = drawerLokasi;
                                });
                                Navigator.pushNamed(context, '/traplasio');
                              },
                            ),
                            ListTile(
                              title: Text("Gudang FGWC"),
                              onTap: () {
                                setState(() {
                                  drawerLokasi = "FGC";
                                  td.drawerLokasi = drawerLokasi;
                                });
                                Navigator.pushNamed(context, '/traplasio');
                              },
                            ),
                            ListTile(
                              title: Text("Gudang Miring"),
                              onTap: () {
                                setState(() {
                                  drawerLokasi= "GDM";
                                  td.drawerLokasi = drawerLokasi;
                                });
                                Navigator.pushNamed(context, '/traplasio');
                              },
                            ),
                          ],
                        ),
                        // ExpansionTile(
                        //   textColor: Colors.black,
                        //   iconColor: Colors.black,
                        //   title: Text(
                        //     "Gudang Mangli",
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   //add icon
                        //   childrenPadding: EdgeInsets.only(left: 30),
                        //   children: [
                        //     ListTile(
                        //       title: Text("Gudang Tengah"),
                        //       onTap: () {
                        //         setState(() {
                        //           drawerLokasi = "MGL";
                        //           td.drawerLokasi = drawerLokasi;
                        //         });
                        //         Navigator.pushNamed(context, '/traplasio');
                        //       },
                        //     ),
                        //     ListTile(
                        //       title: Text("Gudang Air Biru"),
                        //       onTap: () {},
                        //     ),
                        //   ],
                        // ),
                        //more child menu
                      ],
                    ),
                    // ExpansionTile(
                    //   textColor: Colors.black,
                    //   iconColor: Colors.black,
                    //   title: Text(
                    //     "CRUD The Momi",
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   leading: Icon(
                    //     Icons.edit_note_rounded,
                    //     color: Colors.black,
                    //     size: 35,
                    //   ),
                    //   //add icon
                    //   childrenPadding: EdgeInsets.only(left: 60),
                    //   //children padding
                    //   children: [
                    //     ListTile(
                    //       title: Text("CRUD Lokasi"),
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(builder: (context) => const EditAlat()),
                    //           );
                    //         }
                    //     ),
                    //     ListTile(
                    //       title: Text("CRUD Alat"),
                    //       onTap: () {
                    //         setState(() {
                    //
                    //         });
                    //       },
                    //     ),
                    //     ListTile(
                    //       title: Text("CRUD Batas"),
                    //       onTap: () {
                    //         setState(() {
                    //
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Selesai Drawer
      // Mulai Body
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {
            getData();
            getNotification();
            cekSensor();
          });
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF000000),
            ),
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                    "Gudang "+ drawerLokasi,
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
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF000000),
                ),
                alignment: AlignmentDirectional.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  
                  child: FutureBuilder<List<MonitoringModel>>(
                      future: getData(),
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
                        if (snapshot.hasData) {
                          var dataLength = snapshot.requireData.length;
                          lineSuhu.clear();
                          lineKelembaban.clear();
                          for (var i = 0; i <= dataLength - 20; i++) {
                            lineSuhu[snapshot.requireData[i].updatedAt] =
                                snapshot.requireData[i].suhu;
                            lineKelembaban[snapshot.requireData[i].updatedAt] =
                                snapshot.requireData[i].kelembaban;
                          }
                          return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 300,
                                  width: double.infinity,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE8CB79),
                                    borderRadius: BorderRadius.circular(20),

                                  ),
                                  child: AnimatedLineChart(
                                    LineChart.fromDateTimeMaps(
                                        [lineSuhu, lineKelembaban],
                                        [Colors.green, Colors.blue],
                                        ['', '']),
                                    key: _refreshKey,
                                    gridColor: Colors.black,
                                    textStyle: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    toolTipColor: Color(0xFFE8CB79),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.linear_scale,
                                      color: Colors.green,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Suhu",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFE8CB79),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.linear_scale,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Kelembaban",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFE8CB79),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xFFE8CB79),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  30.0, 20.0, 15.0, 0.0),
                                              child: Row(
                                                children: [
                                                  // cf.createIcon(
                                                  //   icon: Icons.date_range,
                                                  //   size: 35
                                                  // ),
                                                  Icon(
                                                    Icons.date_range,
                                                    color: Color(0xFF000000),
                                                    size: 35,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "Latest Update",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black54),
                                                        ),
                                                        Text(
                                                          _formattingDate(
                                                              "${snapshot.data![0].updatedAt}"),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                            Color(0xFF000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //Sensor 1
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(30.0, 20.0, 15.0, 0.0),
                                              //.symmetric(vertical: 30.0, horizontal: 30.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  cf.createText(
                                                    label: "Sensor 1",
                                                    fontSize: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      cf.createText(
                                                        label: "${snapshot.data![0].suhu.toStringAsFixed(1)}°C",
                                                        fontSize: 16,
                                                      ),
                                                      cf.createText(
                                                        label: "${snapshot.data![0].kelembaban.toStringAsFixed(1)}%",
                                                        fontSize: 16,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 1";
                                                            ds.namaSensor = namaSensor;
                                                            ds.drawerLokasi = drawerLokasi;
                                                          });
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => ds.DetailSensorPage()));
                                                        },
                                                        splashColor:
                                                        Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 1";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //Sensor 2
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 30.0, 0.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Sensor 2",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFFE8CB79),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data![0].suhu}°C",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFE8CB79),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${snapshot.data![0].kelembaban}%",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFE8CB79),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 2";
                                                            ds.namaSensor = namaSensor;
                                                            ds.drawerLokasi = drawerLokasi;
                                                          });
                                                        },
                                                        splashColor:
                                                        Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 2";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //Sensor 3
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(30.0, 20.0, 15.0, 0.0),
                                              //.symmetric(vertical: 30.0, horizontal: 30.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  cf.createText(
                                                    label: "Sensor 3",
                                                    fontSize: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      cf.createText(
                                                        label: "${snapshot.data![0].suhu.toStringAsFixed(1)}°C",
                                                        fontSize: 16,
                                                      ),
                                                      cf.createText(
                                                        label: "${snapshot.data![0].kelembaban.toStringAsFixed(1)}%",
                                                        fontSize: 16,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 3";
                                                            ds.namaSensor = namaSensor;
                                                            ds.drawerLokasi = drawerLokasi;
                                                          });
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => ds.DetailSensorPage()));
                                                        },
                                                        splashColor:
                                                        Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 3";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //Sensor 4
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 30.0, 0.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Sensor 4",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFFE8CB79),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data![0].suhu}°C",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFE8CB79),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${snapshot.data![0].kelembaban}%",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFE8CB79),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 4";
                                                          });
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 4";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //Sensor 5
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(30.0, 20.0, 15.0, 0.0),
                                              //.symmetric(vertical: 30.0, horizontal: 30.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  cf.createText(
                                                    label: "Sensor 5",
                                                    fontSize: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      cf.createText(
                                                        label: "${snapshot.data![0].suhu.toStringAsFixed(1)}°C",
                                                        fontSize: 16,
                                                      ),
                                                      cf.createText(
                                                        label: "${snapshot.data![0].kelembaban.toStringAsFixed(1)}%",
                                                        fontSize: 16,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 5";
                                                            ds.drawerLokasi = drawerLokasi;
                                                          });
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => ds.DetailSensorPage()));
                                                        },
                                                        splashColor:
                                                        Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 5";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //Sensor 6
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 30.0, 0.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Sensor 6",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFFE8CB79),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data![0].suhu}°C",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFE8CB79),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${snapshot.data![0].kelembaban}%",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFE8CB79),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 6";
                                                          });
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 6";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //Sensor 7
                                            Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.fromLTRB(30.0, 20.0, 15.0, 0.0),
                                              //.symmetric(vertical: 30.0, horizontal: 30.0),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFF000000),
                                              ),
                                              child: Column(
                                                children: [
                                                  cf.createText(
                                                    label: "Sensor 7",
                                                    fontSize: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      cf.createIcon(
                                                        icon: Icons.thermostat,
                                                      ),
                                                      cf.createIcon(
                                                          icon: Icons.water_drop_rounded),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      cf.createText(
                                                        label: "${snapshot.data![0].suhu.toStringAsFixed(1)}°C",
                                                        fontSize: 16,
                                                      ),
                                                      cf.createText(
                                                        label: "${snapshot.data![0].kelembaban.toStringAsFixed(1)}%",
                                                        fontSize: 16,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 7";
                                                            ds.drawerLokasi = drawerLokasi;
                                                          });
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => ds.DetailSensorPage()));
                                                        },
                                                        splashColor:
                                                        Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFE8CB79),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Icon(
                                                            Icons.backup_table,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            namaSensor = "Sensor 7";
                                                            lineSuhu.clear();
                                                            lineKelembaban.clear();
                                                            for (var i = 0; i <= dataLength - 20; i++) {
                                                              lineSuhu[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].suhu;
                                                              lineKelembaban[snapshot.requireData[i].updatedAt] = snapshot.requireData[i].kelembaban;
                                                            }
                                                          });
                                                          showShortToast();
                                                        },
                                                        splashColor: Colors.blue,
                                                        child: Container(
                                                          padding: EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFE8CB79),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Icon(
                                                            Icons.insert_chart_outlined_outlined,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ]);
                        }
                        return Container();
                      }),
                ),
              )
            ]),
          ),
        ),
      ),
      // Selesai Body
    );
  }
}
