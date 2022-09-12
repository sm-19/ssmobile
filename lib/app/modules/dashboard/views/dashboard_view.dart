// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/informasi/views/informasi_view.dart';
import 'package:smartschool/app/modules/jadwal/views/jadwal_view.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import 'package:smartschool/app/modules/matapelajaran/views/matapelajaran_view.dart';
import 'package:smartschool/app/modules/profil/views/profil_view.dart';
import 'package:smartschool/app/modules/raport/views/raport_view.dart';
import 'package:smartschool/app/modules/ujian/views/ujian_view.dart';
import '../controllers/dashboard_controller.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String NISN = "";
  String namasiswa = "";

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getString("login");
    if (islogin != null) {
      setState(() {
        NISN = pref.getString("nisn")!;
        namasiswa = pref.getString("nama")!;
      });
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
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("login");
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginView(),
      ),
      (route) => false,
    );
  }

  int _currentIndex = 0;

  List cardList = [
    'assets/foto/1.png',
    'assets/foto/2.jpg',
    'assets/foto/3.png',
    'assets/foto/4.jpg',
    'assets/foto/5.jpg',
    'assets/foto/6.jpg',
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  var response;
  Dio dio = Dio();
  bool error = false;
  bool loading = false;
  String errmsg = "";
  var apidata;
  @override
  void initState() {
    getData();
    getPref();
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    String url = "https://www.tampilan.sekolahpintar.my.id/Api/api/pengumuman";
    var response = await dio.get(url);
    apidata = response.data;

    if (response.statusCode == 200) {
      if (apidata == "error") {
        error = true;
        errmsg = apidata["msg"];
      }
    } else {
      error = true;
      errmsg = "Error while fetching data.";
    }
    loading = false;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(93, 0, 0, 0),
                      blurRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dashboard",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 25)),
                      Container(
                        child: InkWell(
                          onTap: () {
                            logOut();
                          },
                          child: Icon(
                            Icons.logout_sharp,
                            color: Color.fromARGB(255, 216, 88, 88),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    height: 1,
                    color: Color.fromARGB(66, 0, 0, 0),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Hello, ",
                                style: new TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            Icon(
                              Icons.emoji_emotions_sharp,
                              color: Color.fromARGB(255, 226, 205, 98),
                            )
                          ],
                        ),
                        Text(namasiswa,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                  height: 165,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
              items: cardList.map((item) {
                return ItemCard(title: item.toString());
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(cardList, (index, url) {
                return Container(
                  width: _currentIndex == index ? 18 : 7.0,
                  height: 7.0,
                  margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _currentIndex == index
                          ? Color.fromARGB(255, 48, 145, 164)
                          : Color.fromARGB(255, 112, 112, 112)),
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(49, 0, 0, 0),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyMenu(
                      title: "Pelajaran",
                      icon: Icons.layers,
                      color: Color.fromARGB(255, 189, 118, 51)),
                  MyMenu(
                      title: "Jadwal",
                      icon: Icons.event_note,
                      color: Color.fromARGB(255, 158, 173, 58)),
                  MyMenu(
                      title: "Ujian",
                      icon: Icons.assignment,
                      color: Color.fromARGB(255, 192, 64, 64)),
                  MyMenu(
                      title: "Raport",
                      icon: Icons.poll,
                      color: Color.fromARGB(255, 145, 95, 163)),
                  MyMenu(
                      title: "Profil",
                      icon: Icons.person,
                      color: Color.fromARGB(255, 41, 81, 103))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pegumuman",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16)),
                  InkWell(
                    child: Text("Lihat Semua",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 213, 193, 11),
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InformasiView()));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: loading
                      ? CircularProgressIndicator()
                      : error
                          ? Text("Error: $errmsg")
                          : ListView(
                              //if everything fine, show the JSON as widget
                              children:
                                  apidata['data'].map<Widget>((pengumuman) {
                                return InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 64, 139, 176),
                                              blurRadius: 1,
                                            )
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/gambar/pengumuman.png",
                                            width: 50.0,
                                            height: 50.0,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pengumuman['judul'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  pengumuman['detail'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      var judul = pengumuman['judul'];
                                      var isi = pengumuman['detail'];
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildAboutDialog(
                                                context, judul, isi),
                                      );
                                      // Perform some action
                                    });
                              }).toList(),
                            )),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAboutDialog(BuildContext context, var judul, var isi) {
  return new AlertDialog(
    title: Text(judul),
    content: new ListView(
      children: <Widget>[Text(isi)],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Ok'),
      ),
    ],
  );
}

class ItemCard extends StatelessWidget {
  final String title;
  const ItemCard({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(179, 224, 119, 119),
            blurRadius: 4,
          )
        ],
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(title)),
      ),
    );
  }
}

class MyMenu extends StatelessWidget {
  MyMenu({required this.title, required this.color, required this.icon});
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Container(
          width: 60,
          height: 60,
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: color,
              ),
              Text(
                title,
                style: new TextStyle(fontSize: 12.0, color: color),
              )
            ],
          )),
        ),
        onTap: () {
          if (title == "Pelajaran") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MatapelajaranView()));
          }
          if (title == "Jadwal") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => JadwalView()));
          }
          if (title == "Ujian") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UjianView()));
          }
          if (title == "Raport") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RaportView()));
          }
          if (title == "Profil") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProfilView()));
          }
        },
      ),
    );
  }
}
