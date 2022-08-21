import 'dart:ui';

import 'package:flutter/material.dart';
import "package:buttons_tabbar/buttons_tabbar.dart";
import 'package:get/get.dart';
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
  var apidata;
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
    String url = "https://www.sekolahpintar.my.id/Api/api/jadwal";
    var response = await dio.get(url);
    apidata = response.data;
    senin = apidata['data'].where((o) => o['hari'] == "1").toList();
    selasa = apidata['data'].where((o) => o['hari'] == "2").toList();
    rabu = apidata['data'].where((o) => o['hari'] == "3").toList();
    kamis = apidata['data'].where((o) => o['hari'] == "4").toList();
    jumat = apidata['data'].where((o) => o['hari'] == "5").toList();
    sabtu = apidata['data'].where((o) => o['hari'] == "6").toList();

    print(senin);

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
  Widget build(
    BuildContext context,
  ) {
    var hari = Map<String, String>();
    hari['1'] = 'Senin';
    hari['2'] = 'Selasa';
    hari['3'] = 'Rabu';
    hari['4'] = 'Kamis';
    hari['5'] = 'Jumat';
    hari['5'] = 'Sabtu';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(5),
                        bottomRight: const Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("JADWAL SEKOLAH",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontSize: 20)),
                    Container(
                      color: Color.fromARGB(255, 88, 88, 88),
                      height: 1,
                      margin: EdgeInsets.only(top: 5),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: DefaultTabController(
                      length: 6,
                      child: Column(
                        children: <Widget>[
                          ButtonsTabBar(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            borderWidth: 1,
                            borderColor: Color.fromARGB(255, 34, 165, 172),
                            unselectedBorderColor:
                                Color.fromARGB(255, 34, 165, 172),
                            unselectedBackgroundColor:
                                Color.fromARGB(255, 34, 165, 172),
                            unselectedLabelStyle: TextStyle(
                                color: Color.fromARGB(255, 253, 253, 253)),
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
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
                                text: "Rabu",
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
                                Container(
                                    alignment: Alignment.center,
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : error
                                            ? Text("Error: $errmsg")
                                            : ListView(
                                                //if everything fine, show the JSON as widget
                                                children:
                                                    senin.map<Widget>((mapel) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0), //<-- SEE HERE
                                                        ),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              DefaultTextStyle(
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        3,
                                                                        5),
                                                                fontSize: 12),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/gambar/jadwal.png",
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      mapel['nama_pelajaran']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                              Text(hari[mapel['hari']].toString() + ", " + mapel['jam_mulai'] + " - " + mapel['jam_selesai'])
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
                                              )),
                                Container(
                                    alignment: Alignment.center,
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : error
                                            ? Text("Error: $errmsg")
                                            : ListView(
                                                //if everything fine, show the JSON as widget
                                                children:
                                                    selasa.map<Widget>((mapel) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0), //<-- SEE HERE
                                                        ),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              DefaultTextStyle(
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        3,
                                                                        5),
                                                                fontSize: 12),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/gambar/jadwal.png",
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      mapel['nama_pelajaran']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                              Text(hari[mapel['hari']].toString() + ", " + mapel['jam_mulai'] + " - " + mapel['jam_selesai'])
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
                                              )),
                                Container(
                                    alignment: Alignment.center,
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : error
                                            ? Text("Error: $errmsg")
                                            : ListView(
                                                //if everything fine, show the JSON as widget
                                                children:
                                                    rabu.map<Widget>((mapel) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0), //<-- SEE HERE
                                                        ),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              DefaultTextStyle(
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        3,
                                                                        5),
                                                                fontSize: 12),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/gambar/jadwal.png",
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      mapel['nama_pelajaran']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                              Text(hari[mapel['hari']].toString() + ", " + mapel['jam_mulai'] + " - " + mapel['jam_selesai'])
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
                                              )),
                                Container(
                                    alignment: Alignment.center,
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : error
                                            ? Text("Error: $errmsg")
                                            : ListView(
                                                //if everything fine, show the JSON as widget
                                                children:
                                                    kamis.map<Widget>((mapel) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0), //<-- SEE HERE
                                                        ),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              DefaultTextStyle(
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        3,
                                                                        5),
                                                                fontSize: 12),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/gambar/jadwal.png",
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      mapel['nama_pelajaran']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                              Text(hari[mapel['hari']].toString() + ", " + mapel['jam_mulai'] + " - " + mapel['jam_selesai'])
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
                                              )),
                                Container(
                                    alignment: Alignment.center,
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : error
                                            ? Text("Error: $errmsg")
                                            : ListView(
                                                //if everything fine, show the JSON as widget
                                                children:
                                                    jumat.map<Widget>((mapel) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0), //<-- SEE HERE
                                                        ),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              DefaultTextStyle(
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        3,
                                                                        5),
                                                                fontSize: 12),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/gambar/jadwal.png",
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      mapel['nama_pelajaran']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                              Text(hari[mapel['hari']].toString() + ", " + mapel['jam_mulai'] + " - " + mapel['jam_selesai'])
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
                                              )),
                                Container(
                                    alignment: Alignment.center,
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : error
                                            ? Text("Error: $errmsg")
                                            : ListView(
                                                //if everything fine, show the JSON as widget
                                                children:
                                                    sabtu.map<Widget>((mapel) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0), //<-- SEE HERE
                                                        ),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              DefaultTextStyle(
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        3,
                                                                        5),
                                                                fontSize: 12),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/gambar/jadwal.png",
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      mapel['nama_pelajaran']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                              Text(hari[mapel['hari']].toString() + ", " + mapel['jam_mulai'] + " - " + mapel['jam_selesai'])
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
                                              )),
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
