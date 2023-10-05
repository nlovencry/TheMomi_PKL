import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:the_momi/lasio_model.dart';
import 'package:the_momi/edit_lasio_page.dart' as el;
import 'package:the_momi/trap_model.dart';
import 'myapp.dart';
import 'package:http/http.dart' as http;
import 'package:the_momi/add_lasio_page.dart' as al;

var id_trap;
var id_trap_detail;
var path_img;
var msgToast;
var nama_trap;
var drawerLokasi;
List<LasioModel> listLasio = [];

class TrapDetailPage extends StatefulWidget {
  final TrapModel dataTrap;
  const TrapDetailPage({Key? key, required this.dataTrap}) : super(key: key);

  @override
  State<TrapDetailPage> createState() => _TrapDetailPageState();
}

class _TrapDetailPageState extends State<TrapDetailPage> {
  String _formattingDate(String rawDate) {
    var dateFormat = DateFormat('d MMM yyyy');
    var date = DateTime.parse(rawDate);
    return dateFormat.format(date);
  }

  Future<List<LasioModel>> getDataLasio() async {
    // var url = "http://10.10.10.100/api/getLasio.php";
    var url = "https://mio.ptmdr.co.id/Themomi/getLasio";
    final response = await http
        .post(Uri.parse(url), body: {'id_trap': widget.dataTrap.idTrap});
    setState(() {
      listLasio = lasioModelFromJson(response.body);
    });
    return listLasio;
  }

  void shortToast() {
    Fluttertoast.showToast(
        msg: msgToast, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
  }

  void deleteLasio() async {
    var url = "https://mio.ptmdr.co.id/Themomi/deleteLasio";
    final response = await http
        .post(Uri.parse(url), body: {'id_trap_detail': id_trap_detail});
    if (response.statusCode == 200) {
      Navigator.pop(context);
      getDataLasio();
      msgToast = "Data Berhasil Dihapus";
      shortToast();
    } else {
      msgToast = "Data Gagal Dihapus";
      shortToast();
    }
  }

  showAlertDeleteLasio(BuildContext context) {
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
            id_trap_detail = id_trap_detail;
            deleteLasio();
          });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFFE8CB79),
      title: Text("Hapus Lasio"),
      content:
      Text("Apakah anda yakin menghapus Lasio?"),
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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLasio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: SingleChildScrollView(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              setState(() {
                getDataLasio();
              });
            },
            child: Center(
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
                          nama_trap,
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
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFBC8746),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            al.id_trap = id_trap;
                            nama_trap = nama_trap;
                            al.nama_trap = nama_trap;
                            al.drawerLokasi = drawerLokasi;
                          });
                          var cb = await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => al.AddLasioPage()));
                          getDataLasio();
                        },
                        child: Card(
                          color: Color(0xFFBC8746),
                          child: ListTile(
                            title: Text(
                              "Tambah Data Lasio",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              onTap: () async {
                                setState(() {
                                  al.id_trap = id_trap;
                                  nama_trap = nama_trap;
                                  al.nama_trap = nama_trap;
                                });
                                var cb = await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => al.AddLasioPage()));
                                getDataLasio();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Table Lasio FGW",
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //         color: Color(0xFFE8CB79),
                    //       ),
                    //     ),
                    //     SizedBox(width: 10),
                    //     Container(
                    //       width: 100,
                    //       height: 50,
                    //       padding: EdgeInsets.all(5),
                    //       decoration: BoxDecoration(
                    //         color: Color(0xFFE8CB79),
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       child: InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             al.id_trap = id_trap;
                    //             Navigator.of(context).push(MaterialPageRoute(
                    //                 builder: (context) => al.AddLasioPage()));
                    //           });
                    //         },
                    //         splashColor: Colors.blue,
                    //         child: Center(
                    //           child: Text(
                    //             'Tambah +',
                    //             style: TextStyle(
                    //               color: Color(0xFF000000),
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              decoration: BoxDecoration(
                                color: Color(0xFFE8CB79),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              columns: <DataColumn>[
                                DataColumn(label: Text("Tanggal")),
                                DataColumn(label: Text("Jam")),
                                DataColumn(label: Text("Jumlah")),
                                DataColumn(label: Text("Opsi"))
                              ],
                              rows: listLasio
                                  .map<DataRow>((item) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                              _formattingDate("${item.tgl}"))),
                                          DataCell(Text("${item.createdAt}")),
                                          DataCell(Text("${item.jumlah}")),
                                          DataCell(Row(
                                            children: [
                                              InkWell(
                                                child: Icon(Icons.edit),
                                                onTap: () async {
                                                  setState(() {
                                                    id_trap_detail = item.idTrapDetail;
                                                    el.id_trap_detail = id_trap_detail;
                                                    el.id_trap = item.idTrap;
                                                    el.nama_trap = nama_trap;
                                                    // el.path_img = item.image;
                                                  });
                                                  var cb = await Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => new el.EditLasioPage(dataLs: item,)));
                                                  getDataLasio();
                                                },
                                              ),
                                              SizedBox(width: 10),
                                              InkWell(
                                                child: Icon(Icons.delete),
                                                onTap: () {
                                                  setState(() {
                                                    id_trap_detail = item.idTrapDetail;
                                                    showAlertDeleteLasio(context);
                                                  });
                                                }
                                              ),
                                            ],
                                          )),
                                        ],
                                      ))
                                  .toList())),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
