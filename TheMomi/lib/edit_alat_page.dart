import 'package:flutter/material.dart';
import 'myapp.dart';

class EditAlat extends StatefulWidget {
  const EditAlat({Key? key}) : super(key: key);

  @override
  State<EditAlat> createState() => _EditAlatState();
}

class _EditAlatState extends State<EditAlat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(),
      ),
      body: Container(
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          "CRUD Lokasi",
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
                    ),
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
              child: Container(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tambah Lokasi",
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
                          children: [
                            Card(
                        color: Color(0xFFE8CB79),
                        margin: EdgeInsets.all(5),
                              child: ListTile(
                                title: Text(
                            "FGWB",
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
                                InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                                  onTap: () {

                                  }
                        ),
                      ),
                            Card(
                        color: Color(0xFFE8CB79),
                        margin: EdgeInsets.all(5),
                              child: ListTile(
                                title: Text(
                            "FGWC",
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
                                InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      // id_trap = e.idTrap;
                                      // deleteTrap();
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      // id_trap = e.idTrap;
                                      // deleteTrap();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              // id_trap = e.idTrap;
                              // deleteTrap();
                            });
                          },
                        ),
                      ),
                            Card(
                        color: Color(0xFFE8CB79),
                        margin: EdgeInsets.all(5),
                              child: ListTile(
                                title: Text(
                            "GREEN",
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
                                InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      // id_trap = e.idTrap;
                                      // deleteTrap();
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      // id_trap = e.idTrap;
                                      // deleteTrap();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              // id_trap = e.idTrap;
                              // deleteTrap();
                            });
                          },
                        ),
                      ),


          ],

        ),
      ),
    ),
            ),

              ],
    )
    ,
    )
    ,
    );
  }
}
