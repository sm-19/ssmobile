import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 110, 146),
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
                          color: Color.fromARGB(255, 255, 255, 255),
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
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
            ),
            SizedBox(
              height: 20,
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
                          ? Color.fromARGB(255, 81, 222, 250)
                          : Color.fromARGB(255, 255, 255, 255)),
                );
              }),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: GridView.count(
              padding: EdgeInsets.all(5),
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                MyMenu(
                  title: "Pelajaran",
                  icon: Icons.file_open,
                ),
                MyMenu(
                  title: "Jadwal",
                  icon: Icons.calendar_today,
                ),
                MyMenu(title: "Ujian", icon: Icons.file_present),
                MyMenu(title: "Nilai", icon: Icons.score),
                MyMenu(
                  title: "Profil",
                  icon: Icons.person,
                )
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
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18)),
                  Text("Lihat Semua",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 250, 253, 58),
                          fontSize: 15)),
                ],
              ),
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
            color: Color.fromARGB(255, 120, 230, 252),
            blurRadius: 4,
          )
        ],
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(title)),
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
