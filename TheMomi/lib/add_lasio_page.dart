import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_momi/trap_detail_page.dart';
import 'package:the_momi/trap_page.dart';
import 'myapp.dart';

var id_trap;
var path_img;
var msgToast;
var index;
var nama_trap;
var drawerLokasi;
bool? isSuccess;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AddLasioPage extends StatefulWidget {
  static String tag = 'trapDetailPage';
  const AddLasioPage({Key? key}) : super(key: key);

  @override
  State<AddLasioPage> createState() => _AddLasioPageState();
}

class _AddLasioPageState extends State<AddLasioPage> {

  TextEditingController dateController=TextEditingController();
  TextEditingController jumlahController=TextEditingController();

  Future<File?> _onImageButtonPressed(ImageSource source) async {
    try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 30);

      if (image == null) {
        return null;
      }

      File? imageTemp;

      if (source == ImageSource.camera) {
        setState(() {
          path_img = image.path;
        });
      } else {
        imageTemp = File(image.path);
      }

      return imageTemp;
    } on PlatformException {
      return null;
    }
  }

  addLasio() async {
    var url = "https://mio.ptmdr.co.id/Themomi/addLasio";
    final res = http.MultipartRequest('POST', Uri.parse(url));
    res.fields['id_trap'] = id_trap;
    res.fields['tgl'] = dateController.text;
    res.fields['jumlah'] = jumlahController.text;

    var pic = await http.MultipartFile.fromPath('image', path_img);
    res.files.add(pic);

    http.Response response = await http.Response.fromStream(await res.send());
    var result = jsonDecode(response.body);

    if(response.statusCode == 200){
      setState(() {
        msgToast = "Data Berhasil Ditambah";
        showShortToast();
      });
      return true;
    }
  }

  void showShortToast() {
    Fluttertoast.showToast(
        msg: msgToast,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  @override
  void initState(){
    super.initState();
    path_img = null;
    dateController.text="";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(),
      ),
      body:
      Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF000000),
        ),
        child: SingleChildScrollView(
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
                    nama_trap,
                    style: TextStyle(
                      color: Color(0xFFE8CB79),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child:
                Icon(Icons.bug_report,
                  color: Color(0xFFE8CB79),
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              Text("Tambah Data Lasio",
                style: TextStyle(
                  color: Color(0xFFE8CB79),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE8CB79),
                      ),
                      child: TextField(
                        cursorColor: Color(0xFFE8CB79),
                        controller: dateController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today,
                            color: Colors.black,),
                          labelText: "Masukan Hari",
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        readOnly: true,
                        onTap: () async{
                          DateTime? pickedDate=await showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if(pickedDate!=null){
                            String formattedDate=DateFormat("yyyy-MM-dd").format(pickedDate);
                            setState(() {
                              dateController.text=formattedDate.toString();
                            });
                          }else{
                            print("Not selected");
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE8CB79),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: jumlahController,
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
                          icon: Icon(Icons.border_color_outlined,
                            color: Colors.black,),
                          fillColor: Color(0xFFE8CB79),
                          filled: true,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          labelText: 'Jumlah',
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Container(
                    //   padding: EdgeInsets.all(5.0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     color: Color(0xFFE8CB79),
                    //   ),
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //       fillColor: Color(0xFFE8CB79),
                    //       filled: true,
                    //       labelStyle: TextStyle(
                    //         color: Colors.black,
                    //         decorationColor: Colors.transparent,
                    //       ),
                    //       labelText: 'Jumlah Komulatif :',
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Container(
                      height: 70,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE8CB79),
                      ),
                      child:Row(
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          // SizedBox(width: 20),
                          // Text("Foto :"),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: (){
                              _onImageButtonPressed(ImageSource.camera);
                            },
                            child: Container(
                              height: 45,
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:
                              Text("Ambil Foto", style: TextStyle(color: Colors.black, fontSize: 10),),
                            ),
                          ),
                          SizedBox(width: 15),
                          path_img != null ? Image.file(File(path_img)) : Image.asset("assets/images/plus.png")
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFFBC8746),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () async {
                          var ed = await addLasio();
                          if(ed != null){
                            Navigator.pop(context, true);
                          }
                        },
                        splashColor: Colors.blue,
                        child: Center(
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


