import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartschool/app/modules/jadwal/views/jadwal_view.dart';
import 'package:smartschool/app/modules/matapelajaran/views/matapelajaran_view.dart';
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
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    String url = "https://www.sekolahpintar.my.id/Api/api/pengumuman";
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
    setState(() {});
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
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dashboard",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 25)),
                  Image.asset(
                    "assets/gambar/Logout.png",
                    width: 24,
                    height: 24,
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Hy, Dimas Prasedy",
                  style: new TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
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
            Expanded(
                child: GridView.count(
              padding: EdgeInsets.only(left: 20, right: 20),
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                MyMenu(
                    title: "Pelajaran",
                    icon: Icons.file_open,
                    color: Color(0x99BD7533)),
                MyMenu(
                    title: "Jadwal",
                    icon: Icons.calendar_today,
                    color: Color(0x999DAD3A)),
                MyMenu(
                    title: "Ujian",
                    icon: Icons.file_present,
                    color: Color(0x99C04040)),
                MyMenu(
                    title: "Nilai",
                    icon: Icons.score,
                    color: Color(0x99915FA3)),
                MyMenu(
                    title: "Profil",
                    icon: Icons.person,
                    color: Color(0x99295167))
              ],
            )),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pegumuman",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16)),
                  Text("Lihat Semua",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 213, 193, 11),
                          fontSize: 15)),
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
                                  child: Card(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 5),
                                      color: Color.fromARGB(255, 172, 230, 225),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/gambar/pengumuman.png",
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pengumuman['judul'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(pengumuman['detail']),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                );
                              }).toList(),
                            )),
            ),
          ],
        ),
      ),
    );
  }
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
            color: Color.fromARGB(255, 162, 218, 255),
            blurRadius: 4,
          )
        ],
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(title)),
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
      color: color,
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
              style: new TextStyle(
                  fontSize: 12.0, color: Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        )),
        onTap: () {
          if (title == "Pelajaran") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MatapelajaranView()));
          }
          if (title == "Jadwal") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => JadwalView()));
          }
        },
      ),
    );
  }
}
