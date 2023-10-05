import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_momi/detail_sensor_minute_page.dart';
import 'package:the_momi/home_page.dart';
import 'package:the_momi/trap_detail_page.dart';
import 'package:the_momi/trap_page.dart';
import 'splash_screen.dart';
import 'package:the_momi/add_lasio_page.dart';

var routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  // print(username);
  var index;
  runApp(MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/detailsensorpermenit': (context) => DetailSensorMinutePage(),
        '/traplasio': (context) => TrapPage(),
        '/trapdetailpage': (context) => TrapDetailPage(dataTrap: listTrap[index],),
      },
      debugShowCheckedModeBanner: false,
      home: username == null ? SplashScreen() : HomePage()));
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: routes,
    );
  }
}


