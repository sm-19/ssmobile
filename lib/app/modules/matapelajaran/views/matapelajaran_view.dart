import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/home/views/home_view.dart';
import '../controllers/matapelajaran_controller.dart';
import 'package:dio/dio.dart';

class MatapelajaranView extends GetView<MatapelajaranController> {
  const MatapelajaranView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MapelListState();
  }
}

class MapelListState extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapelListState> {
  Dio dio = Dio();
  var pelajaran, datapelajaran;
  var response;
  var kodekelas, idlogin;
  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  var apidata; //for decoded JSON data

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url =
        "https://www.tampilan.sekolahpintar.my.id/Api/api/jadwal_pelajaran";
    response = await dio.get(url);
    apidata = response.data;
    idlogin = pref.getString('idlogin');
    kodekelas = pref.getString("kelas");
    if (pref.getString("login") == 'siswa') {
      datapelajaran =
          apidata['data'].where((o) => o['kode_kelas'] == kodekelas).toList();
    }
    if (pref.getString("login") == 'guru') {
      datapelajaran =
          apidata['data'].where((o) => o['id_guru'] == idlogin).toList();
    }
    loading = false;
    setState(() {});
  }

  void mapelSession(idmapel, namamapel, kelas, idkelas) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("mapelid", idmapel);
    await pref.setString("mapelnama", namamapel);
    await pref.setString("kelas", kelas);
    await pref.setString("idkelas", idkelas);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeView()));
  }

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
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
                            "Mata Pelajaran",
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
                    alignment: Alignment.center,
                    child: loading
                        ? CircularProgressIndicator()
                        : error
                            ? Text("Error: $errmsg")
                            : ListView(
                                //if everything fine, show the JSON as widget
                                children: datapelajaran.map<Widget>((mapel) {
                                  return InkWell(
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                  113, 203, 78, 78),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10.0), //<-- SEE HERE
                                          ),
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 5),
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/gambar/Study.png",
                                                  width: 50.0,
                                                  height: 50.0,
                                                  fit: BoxFit.contain,
                                                ),
                                                SizedBox(width: 10),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        mapel['pelajaran'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        mapel['nama_pelajaran'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      onTap: () {
                                        mapelSession(
                                            mapel['id_pelajaran'],
                                            mapel['nama_pelajaran'],
                                            mapel['kode_kelas'],
                                            mapel['id_kelas']);
                                      });
                                }).toList(),
                              )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
