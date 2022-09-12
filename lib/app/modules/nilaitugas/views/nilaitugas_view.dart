import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import '../controllers/nilaitugas_controller.dart';

// ignore: must_be_immutable
class NilaitugasView extends GetView<NilaitugasController> {
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
  var apidata, apidatasiswa;
  var pelajaran, datapelajaran;
  var response, responsesiswa;
  var idsiswa, countsiswa;

  @override
  void initState() {
    getPref();
    super.initState();
  }

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getString("login");
    if (islogin != null) {
      idsiswa = pref.getString("kelas")!;
      response = await dio.get(url);
      apidata = response.data;
      datapelajaran = apidata['data']
          .where((o) =>
              o['kode_kelas'] == idsiswa &&
              o['id_pelajaran'] == pref.getString("mapelid"))
          .toList();
      pelajaran = datapelajaran[0];
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginView(),
        ),
        (route) => false,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FutureBuilder(builder:
                (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (pelajaran != null) {
                return Column(
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
                                  "Nilai Tugas",
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
                  ],
                );
              } else {
                return Container();
              }
            }),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [],
                )),
          ],
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
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color,
          ),
          borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
        ),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: color),
              margin: EdgeInsets.only(right: 10),
              height: 70,
              width: 70,
              child: Icon(
                icon,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.left,
            )
          ],
        ));
  }
}
