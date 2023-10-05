import 'package:flutter/material.dart';
import 'notif_page.dart';

class MyAppBar extends StatefulWidget {
  MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
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
                      child: InkWell(
                        child: Text(
                          "Keluar",
                          style: TextStyle(
                            color: Color(0xFFE8CB79),
                          ),
                        ),
                        onTap: (){
                        },
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
    );
  }
}
