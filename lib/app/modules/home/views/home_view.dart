import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/absensi/views/absensi_view.dart';
import 'package:smartschool/app/modules/akses/views/akses_view.dart';
import 'package:smartschool/app/modules/materi/views/materi_view.dart';
import 'package:smartschool/app/modules/nilai/views/nilai_view.dart';
import 'package:smartschool/app/modules/tugas/views/tugas_view.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return HomeState();
  }
}

class HomeState extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeState> {
  Dio dio = Dio();
  String url =
      "https://www.tampilan.sekolahpintar.my.id/Api/api/jadwal_pelajaran";
  var apidata, response;
  var pelajaran, datapelajaran;
  String idmapel = '', islogin = '';

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    idmapel = pref.getString("mapelid")!;
    islogin = pref.getString("login")!;
    response = await dio.get(url);
    apidata = response.data;
    datapelajaran =
        apidata['data'].where((o) => o['id_pelajaran'] == idmapel).toList();
    pelajaran = datapelajaran[0];
    setState(() {});
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (pelajaran != null) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 172, 43, 43),
                              borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(15),
                                  bottomRight: const Radius.circular(15))),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pelajaran['nama_pelajaran'],
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20)),
                                ],
                              ),
                              Container(
                                color: Color.fromARGB(255, 255, 255, 255),
                                height: 1,
                                margin: EdgeInsets.only(top: 10),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(20),
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(179, 0, 0, 0),
                                      blurRadius: 1,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "Menu",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 172, 43, 43)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(55, 0, 0, 0),
                              blurRadius: 1,
                            )
                          ],
                        ),
                        child: DefaultTextStyle(
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("   : "),
                                    Text("   : "),
                                    Text("   : "),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pelajaran['nama_guru']),
                                    Text(pelajaran['kode_kelas']),
                                    Text(pelajaran['jam_mulai'] +
                                        " - " +
                                        pelajaran['jam_selesai']),
                                  ],
                                ),
                              ],
                            )))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(30, 0, 0, 0),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: MyMenu(
                          color: Color.fromARGB(255, 192, 64, 64),
                          title: "Materi",
                          icon: Icons.auto_stories,
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MateriView())),
                      ),
                      InkWell(
                        child: MyMenu(
                            title: "Tugas",
                            icon: Icons.assignment,
                            color: Color.fromARGB(255, 41, 81, 103)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TugasView())),
                      ),
                      InkWell(
                        child: MyMenu(
                            title: "Absensi",
                            icon: Icons.check_box,
                            color: Color.fromARGB(255, 158, 173, 58)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => islogin == 'guru'
                                    ? AksesView()
                                    : AbsensiView())),
                      ),
                      InkWell(
                        child: MyMenu(
                            title: "Nilai",
                            icon: Icons.view_list,
                            color: Color.fromARGB(255, 145, 95, 163)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NilaiView())),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      }),
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
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 30.0, color: color),
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: new TextStyle(fontSize: 12.0, color: color),
        )
      ],
    ));
  }
}
