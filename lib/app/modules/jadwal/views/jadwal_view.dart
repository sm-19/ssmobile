import 'package:flutter/material.dart';
import "package:buttons_tabbar/buttons_tabbar.dart";
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/jadwal_controller.dart';
import 'package:dio/dio.dart';

class JadwalView extends GetView<JadwalController> {
  const JadwalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JadwalListState();
  }
}

class JadwalListState extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<JadwalListState> {
  var response;
  Dio dio = Dio();
  bool error = false;
  bool loading = false;
  String errmsg = "";
  var apidata, kodekelas;
  var senin, selasa, rabu, kamis, jumat, sabtu;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url =
        "https://www.tampilan.sekolahpintar.my.id/Api/api/jadwal_pelajaran";
    response = await dio.get(url);
    apidata = response.data;
    kodekelas = pref.getString("kelas")!;

    senin = apidata['data']
        .where((o) => o['hari'] == "1" && o['kode_kelas'] == kodekelas)
        .toList();
    selasa = apidata['data']
        .where((o) => o['hari'] == "2" && o['kode_kelas'] == kodekelas)
        .toList();
    rabu = apidata['data']
        .where((o) => o['hari'] == "3" && o['kode_kelas'] == kodekelas)
        .toList();
    kamis = apidata['data']
        .where((o) => o['hari'] == "4" && o['kode_kelas'] == kodekelas)
        .toList();
    jumat = apidata['data']
        .where((o) => o['hari'] == "5" && o['kode_kelas'] == kodekelas)
        .toList();
    sabtu = apidata['data']
        .where((o) => o['hari'] == "6" && o['kode_kelas'] == kodekelas)
        .toList();

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

  _listjadwal(waktu) {
    var hari = Map<String, String>();
    hari['1'] = 'Senin';
    hari['2'] = 'Selasa';
    hari['3'] = 'Rabu';
    hari['4'] = 'Kamis';
    hari['5'] = 'Jumat';
    hari['5'] = 'Sabtu';
    return Container(
        alignment: Alignment.center,
        child: loading
            ? CircularProgressIndicator()
            : error
                ? Text("Error: $errmsg")
                : ListView(
                    //if everything fine, show the JSON as widget
                    children: waktu.map<Widget>((mapel) {
                      return InkWell(
                        child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color.fromARGB(86, 172, 43, 43),
                              ),
                              borderRadius:
                                  BorderRadius.circular(10.0), //<-- SEE HERE
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.all(5),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 3, 5),
                                    fontSize: 12),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/gambar/jadwal.png",
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mapel['nama_pelajaran']
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Guru",
                                                  ),
                                                  Text(
                                                    "Waktu",
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    " : ",
                                                  ),
                                                  Text(
                                                    " : ",
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    mapel['nama_guru'],
                                                    softWrap: true,
                                                  ),
                                                  Text(hari[mapel['hari']]
                                                          .toString() +
                                                      ", " +
                                                      mapel['jam_mulai'] +
                                                      " - " +
                                                      mapel['jam_selesai'])
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    }).toList(),
                  ));
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 60,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        Container(
                          color: Color.fromARGB(255, 255, 255, 255),
                          height: 2,
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
                                color: Color.fromARGB(179, 224, 119, 119),
                                blurRadius: 1,
                              )
                            ],
                          ),
                          child: Text(
                            "Jadwal Pelajaran",
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: DefaultTabController(
                      length: 6,
                      child: Column(
                        children: <Widget>[
                          ButtonsTabBar(
                            backgroundColor: Color.fromARGB(255, 172, 43, 43),
                            borderWidth: 1,
                            borderColor: Color.fromARGB(255, 172, 43, 43),
                            unselectedBorderColor:
                                Color.fromARGB(255, 172, 43, 43),
                            unselectedBackgroundColor:
                                Color.fromARGB(255, 255, 255, 255),
                            unselectedLabelStyle:
                                TextStyle(color: Color.fromARGB(255, 3, 0, 0)),
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            tabs: [
                              Tab(
                                text: "Senin",
                              ),
                              Tab(
                                text: "Selasa",
                              ),
                              Tab(
                                text: " Rabu ",
                              ),
                              Tab(
                                text: "Kamis",
                              ),
                              Tab(
                                text: "Jumat",
                              ),
                              Tab(
                                text: "Sabtu",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[
                                _listjadwal(senin),
                                _listjadwal(selasa),
                                _listjadwal(rabu),
                                _listjadwal(kamis),
                                _listjadwal(jumat),
                                _listjadwal(sabtu),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
