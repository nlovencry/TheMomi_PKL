import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_momi/notif_model.dart';
import 'myapp.dart';

List<NotifModel> listNotif = [];

class NotifPage extends StatefulWidget {

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void getNotification() async {
    var url = "http://10.10.10.100/api/showNotification.php";

    final response = await http.post(Uri.parse(url), body: {
      'locUser': ''
    });
    setState(() {
      listNotif = notifModelFromJson(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Text(
          'THE MOMI',
          style: TextStyle(
            color: Color(0xFFE8CB79),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
            },
            child: Icon(
              Icons.notifications,
              size: 35,
              color: Color(0xFFE8CB79),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: PopupMenuButton(
                color: Colors.black,
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
                      child: Text(
                        "Keluar",
                        style: TextStyle(
                          color: Color(0xFFE8CB79),
                        ),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    print("Username menu is selected.");
                  } else if (value == 1) {
                  }
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 15, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Notifikasi",
                      style: TextStyle(
                        color: Color(0xFFE8CB79),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE8CB79),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: listNotif.map((e) => Card(
                          color: Color(0xFFE8CB79),
                          child: ListTile(
                            leading: Text(
                              e.kodeLokasi,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            title: Text(
                              e.keterangan,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              "suhu: "+e.suhu+" | kelembaban: "+e.kelembaban+"",
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sensor 1",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  e.jam,
                                )
                              ],
                            ),
                          ),
                    )).toList()
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
