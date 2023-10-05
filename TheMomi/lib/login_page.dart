import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_const.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String errormsg;
  late String username;
  late String password;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  startLogin() async {
    String url = "$BASE_URL/login.php";
    // print(url);

    void error(BuildContext context, String error) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(error),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    var response = await http.post(Uri.parse(url), body: {
      'username': usernameController.text, //get the username text
      'password': passwordController.text //get password text
    });

    if (usernameController.text == "" && passwordController.text == "") {
      error(context, "Username dan password tidak boleh kosong!");
      return LoginPage();
    }

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["message"] == "login gagal") {
        setState(() {
          errormsg = jsondata["message"];
          error(context, "Username dan password salah!");
        });
        print("login gagal");
      } else {
        if (jsondata["message"] == "Login Berhasil") {
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("username", usernameController.text);
          await pref.setString("password", passwordController.text);
          await pref.setBool("islogin", true);
          print("berhasil");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context){
                return HomePage();
              }));
          //user shared preference to save data
        } else {
          error(context, "Something went wrong.");
        }
      }
    } else {
      print("login gagal");
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var ambilusername = pref.getString("username") ?? 'username kosong';
    print(ambilusername);
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              CircleAvatar(
                radius: 100,
                backgroundColor:
                Colors.transparent,
                child: Image.asset('assets/images/log.png',
                ),
              ),
              SizedBox(height: 25),
              //Hello again!
              Text(
                'THE MOMI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                  color: Color(0xFFBC8746),
                  fontSize: 30,
                ),
              ),

              SizedBox(height: 25),

              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE8CB79),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),


              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE8CB79),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // sign in button

                Container(
                  height: 50,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFFBC8746),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: (){
                      if (usernameController.value.text == 'ptmdr' &&
                          passwordController.value.text == 'ptmdr') {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return HomePage();
                            }));
                      }
                    },
                    // onTap: () {
                    //   startLogin();
                    // },
                    splashColor: Colors.blue,
                    child: Center(
                      child: Text(
                        'Sign In',
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
      ),

    );
  }
}
