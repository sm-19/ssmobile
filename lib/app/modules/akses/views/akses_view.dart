import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import '../controllers/akses_controller.dart';

class AksesView extends GetView<AksesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 110, 146),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  "assets/gambar/logo.png",
                  width: 200.0,
                  height: 150.0,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Akses Login",
                  style: new TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  MyMenu(
                    title: "Guru",
                    icon: Icons.verified_user,
                    color: Color.fromARGB(231, 87, 161, 100),
                  ),
                  MyMenu(
                    title: "Orang Tua",
                    icon: Icons.unfold_less_rounded,
                    color: Color.fromARGB(231, 146, 126, 13),
                  ),
                  MyMenu(
                    title: "Siswa",
                    icon: Icons.ad_units_rounded,
                    color: Color.fromARGB(255, 159, 47, 47),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyMenu extends StatelessWidget {
  MyMenu({required this.title, required this.icon, required this.color});
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: color,
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 60.0,
            ),
            Text(
              title,
              style: new TextStyle(fontSize: 17.0),
            )
          ],
        )),
        onTap: () {
          if (title == "Guru") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginView(title: "Guru")));
          }
        },
      ),
    );
  }
}
