import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartschool/app/modules/siswa/views/siswa_view.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  String mapel;
  HomeView({required this.mapel});
  @override
  Widget build(BuildContext context) {
    return HomeState(mapel);
  }
}

class HomeState extends StatefulWidget {
  final String mapel;
  HomeState(this.mapel);
  @override
  _MyHomePageState createState() => _MyHomePageState(mapel);
}

class _MyHomePageState extends State<HomeState> {
  final String mapel;
  _MyHomePageState(this.mapel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 110, 146),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(15),
                      bottomRight: const Radius.circular(15))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Menu",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 25)),
                      Icon(Icons.home),
                    ],
                  ),
                  Container(
                    color: Color.fromARGB(255, 0, 0, 3),
                    height: 1,
                    margin: EdgeInsets.only(top: 5),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    mapel.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 38, 126, 144)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                          color: Color.fromARGB(255, 47, 110, 146),
                          borderRadius: new BorderRadius.circular(10)),
                      child: DefaultTextStyle(
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nama Guru"),
                                  Text("Kelas"),
                                  Text("Waktu"),
                                  Text("Jumlah Siswa"),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(" : "),
                                  Text(" : "),
                                  Text(" : "),
                                  Text(" : "),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Sulaiman Majid, S.Kom"),
                                  Text("XII 1"),
                                  Text("Selasa, 07:30 - 08:45"),
                                  Text("20 Orang"),
                                ],
                              ),
                            ],
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: GridView.count(
              padding: EdgeInsets.all(5),
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                MyMenu(
                  title: "Materi",
                  icon: Icons.file_open,
                ),
                MyMenu(
                  title: "Tugas",
                  icon: Icons.task,
                ),
                MyMenu(title: "Absensi", icon: Icons.check_box),
                MyMenu(title: "Siswa", icon: Icons.group)
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class MyMenu extends StatelessWidget {
  MyMenu({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
            ),
            Text(
              title,
              style: new TextStyle(fontSize: 12.0),
            )
          ],
        )),
        onTap: () {
          if (title == "Siswa") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SiswaView()));
          }
        },
      ),
    );
  }
}
