import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_momi/trap_model.dart';
import 'myapp.dart';
import 'package:the_momi/trap_detail_page.dart' as td;
import 'package:http/http.dart' as http;
import 'package:the_momi/home_page.dart' as hp;

var lengthTrap;
var msgToast;
var jml;
var id_trap;
var drawerLokasi;
var nama_trap;
var namaTrapController;
var kodeLokasi;
var banyakTrap;
var jumlahKomulatif;
var rataRata;
var target;
var statusGudang;
List<TrapModel> listTrap = [];

class TrapPage extends StatefulWidget {
  @override
  State<TrapPage> createState() => _TrapPageState();
}

class _TrapPageState extends State<TrapPage> {
  TextEditingController namaTrapController = TextEditingController();
  TextEditingController targetController = TextEditingController();

  void getDataTrap() async {
    /// Testing Scroll View
    var locUser = hp.drawerLokasi;
    try {
      // String Apiurl = "http://10.10.10.100/api/getDataTrap.php";
      String Apiurl = "https://mio.ptmdr.co.id/Themomi/getDataTrap";
      final response =
          await http.post(Uri.parse(Apiurl), body: {'locUser': locUser});
      if (response.statusCode == 200) {
        final dataDecode = await jsonDecode(response.body);
        setState(() {
          listTrap.clear();
          for (var row in dataDecode) {
            listTrap.add(TrapModel.fromJson(row));
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void addTrap() async {
    var url = "https://mio.ptmdr.co.id/Themomi/addTrap";
    var locUser = hp.drawerLokasi;
    // print(namaTrapController);
    // var jumlah_trap = listTrap.length+1;
    final response = await http.post(Uri.parse(url), body: {
      'locUser': locUser,
      'nama_trap': namaTrapController.text,
    });
    if (response.statusCode == 200) {
      setState((){
        Navigator.popAndPushNamed(context, '/traplasio');
      });
      msgToast = "Data Berhasil Ditambah";
      shortToast();
    } else {
      msgToast = "Data Gagal Ditambah";
      shortToast();
    }
  }

  void deleteTrap() async {
    var url = "https://mio.ptmdr.co.id/Themomi/deleteTrap";
    final response =
        await http.post(Uri.parse(url), body: {'id_trap': id_trap});
    if (response.statusCode == 200) {
      Navigator.pop(context);
      getDataTrap();
      msgToast = "Data Berhasil Dihapus";
      shortToast();
    } else {
      msgToast = "Data Gagal Dihapus";
      shortToast();
    }
  }

  showAlertUbahNama(BuildContext context) {
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
      child: Text("Simpan",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        addTrap();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFFE8CB79),
      title: Text("Tambah Nama Trap"),
      content:
      Container(
        child: TextField(
          controller: namaTrapController,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black
              ),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            labelText: 'Nama Trap',
          ),
        ),
      ),
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

  showAlertTarget(BuildContext context) {
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
      child: Text("Simpan",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        addTarget();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFFE8CB79),
      title: Text("Target"),
      content:
      Container(
        child: TextField(
          controller: targetController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black
              ),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            labelText: 'Isi Target',
          ),
        ),
      ),
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

  showAlertDeleteTrap(BuildContext context) {
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
      child: Text("Delete",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          id_trap = id_trap;
          deleteTrap();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFFE8CB79),
      title: Text("Hapus Trap"),
      content:
      Text("Apakah anda yakin untuk menghapus trap?"),
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

  void addTarget() async {
    var url = "https://mio.ptmdr.co.id/Themomi/addTarget";
    var locUser = hp.drawerLokasi;
    final response = await http.post(Uri.parse(url), body: {
      'locUser': locUser,
      'target': targetController.text,
    });
    if (response.statusCode == 200) {
      setState((){
        Navigator.pop(context);
      });
      msgToast = "Data Berhasil Ditambah";
      shortToast();
    } else {
      msgToast = "Data Gagal Ditambah";
      shortToast();
    }
  }

  void getAverage() async {
    var avg;
    var parts;
    var url = "https://mio.ptmdr.co.id/Themomi/getAverage";
    final response = await http.post(Uri.parse(url), body: {
      'locUser': drawerLokasi
    });
    if (response.statusCode == 200) {
      final dataDecode = await jsonDecode(response.body);
    setState(() {
        kodeLokasi = dataDecode[0]['kodeLokasi'];
        avg = dataDecode[0]['rataRata'];
        parts = avg.split('.');
        rataRata = parts[0].trim();
        print(rataRata);
        target = dataDecode[0]['target'];
        statusGudang = dataDecode[0]['statusGudang'];
      });
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  void shortToast() {
    Fluttertoast.showToast(
        msg: msgToast, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
  }

  @override
  void initState() {
    listTrap.clear();
    getDataTrap();
    getAverage();
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {
            listTrap.clear();
            getDataTrap();
            getAverage();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  //Row untuk icon, judul halaman , dan button tambah lasio trap
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "Gudang "+ drawerLokasi,
                              style: TextStyle(
                                color: Color(0xFFE8CB79),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: AlignmentDirectional.centerStart,
                            width: 100,
                            margin: EdgeInsets.only(left: 15),
                          ),
                        // SizedBox(width: 130),
                        Container(
                          child: Text(
                            statusGudang,
                            style: TextStyle(
                              color: Color(0xFFE8CB79),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: AlignmentDirectional.centerEnd,
                          width: 100,
                          margin: EdgeInsets.only(right: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Avg : " + rataRata,
                            style: TextStyle(
                              color: Color(0xFFE8CB79),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          width: 100,
                          margin: EdgeInsets.only(left: 15),
                        ),
                        // SizedBox(width: 130),
                        Container(
                          child: Text(
                            "Target : " + target,
                            style: TextStyle(
                              color: Color(0xFFE8CB79),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                            width: 100,
                            margin: EdgeInsets.only(right: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        showAlertUbahNama(context);
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Tambah Trap",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            Icon(Icons.add,
                            color: Colors.black,
                            ),
                          ],
                        ),
                        height: 50,
                        width: 175,
                        decoration: BoxDecoration(
                          color: Color(0xFFBC8746),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: InkWell(
                        onTap: (){
                          showAlertTarget(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Tambah Target",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.add,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      height: 50,
                      width: 175,
                      decoration: BoxDecoration(
                        color: Color(0xFFBC8746),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8CB79),
                    borderRadius: BorderRadiusDirectional.circular(15.0),
                  ),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        children: listTrap.map((e) => Card(
                          color: Color(0xFFE8CB79),
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(
                              e.namaTrap,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black,
                                    child: Text(
                                      e.jumlahKomulatif,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFFE8CB79)),
                                    ),
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        id_trap = e.idTrap;
                                        showAlertDeleteTrap(context);
                                      });
                                      },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              setState(() {
                                id_trap = e.idTrap;
                                td.id_trap = id_trap;
                                nama_trap = e.namaTrap;
                                td.nama_trap = nama_trap;
                                td.drawerLokasi = drawerLokasi;
                              });
                              var cb = await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => td.TrapDetailPage(dataTrap: e,)));
                              getDataTrap();
                              },
                          ),
                        )).toList()),
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
