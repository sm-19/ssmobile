import 'package:flutter/material.dart';
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
        backgroundColor: Color.fromARGB(255, 47, 110, 146),
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
                    Text("JADWAL PELAJARAN",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 25)),
                    Container(
                      color: Color.fromARGB(255, 0, 0, 3),
                      height: 1,
                      margin: EdgeInsets.only(top: 5),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Text("Senin"),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Text("Selasa"),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Text("Rabu"),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Text("Kamis"),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Text("Jumat"),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Text("Sabtu"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                                      apidata["data"].map<Widget>((mapel) {
                                    return InkWell(
                                      child: Card(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 5),
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.all(10),
                                            child: DefaultTextStyle(
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 100, 157),
                                                  fontSize: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(""),
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
                                                              "",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
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
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              mapel[
                                                                  'nama_guru'],
                                                            ),
                                                            Text(hari[mapel[
                                                                        'hari']]
                                                                    .toString() +
                                                                ", " +
                                                                mapel[
                                                                    'jam_mulai'] +
                                                                " - " +
                                                                mapel[
                                                                    'jam_selesai'])
                                                          ],
                                                        )
                                                      ]),
                                                ],
                                              ),
                                            ),
                                          )),
                                    );
                                  }).toList(),
                                ))),
            ],
          ),
        ),
      ),
    );
  }
}
