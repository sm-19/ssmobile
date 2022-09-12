import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ujian_controller.dart';
import 'package:dio/dio.dart';

class UjianView extends GetView<UjianController> {
  const UjianView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MapelListState();
  }
}

class MapelListState extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapelListState> {
  var response;
  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  var apidata;
  var uts;
  var uas; //for decoded JSON data

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    String url =
        "https://www.tampilan.sekolahpintar.my.id/Api/api/jadwal_ujian";
    var response = await dio.get(url);
    apidata = response.data;
    uts = apidata['data'].where((o) => o['keterangan'] == "UTS").toList();
    uas = apidata['data'].where((o) => o['keterangan'] == "UAS").toList();
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
                            "Jadwal Ujian",
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
                      length: 2,
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
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                            contentPadding:
                                EdgeInsets.only(left: 70, right: 70),
                            tabs: [
                              Tab(
                                text: "UTS",
                              ),
                              Tab(
                                text: "UAS",
                              )
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
                                                    uts.map<Widget>((ujian) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    86,
                                                                    172,
                                                                    43,
                                                                    43),
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
                                                                Flexible(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        ujian[
                                                                            'tanggal'],
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(ujian[
                                                                          'nama_pelajaran']),
                                                                      Text(ujian[
                                                                              'jam_mulai'] +
                                                                          " - " +
                                                                          ujian[
                                                                              'jam_selesai']),
                                                                    ],
                                                                  ),
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
                                                    uas.map<Widget>((ujian) {
                                                  return InkWell(
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    86,
                                                                    172,
                                                                    43,
                                                                    43),
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
                                                                Flexible(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        ujian[
                                                                            'tanggal'],
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(ujian[
                                                                          'nama_pelajaran']),
                                                                      Text(ujian[
                                                                              'jam_mulai'] +
                                                                          " - " +
                                                                          ujian[
                                                                              'jam_selesai']),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  );
                                                }).toList(),
                                              ))
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
