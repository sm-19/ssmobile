import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import '../controllers/siswa_controller.dart';

class SiswaView extends GetView<SiswaController> {
  const SiswaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SiswaListState();
  }
}

class SiswaListState extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SiswaListState> {
  Dio dio = Dio();
  String url =
      "https://www.tampilan.sekolahpintar.my.id/Api/api/jadwal_pelajaran";
  String urlsiswa = "https://www.tampilan.sekolahpintar.my.id/Api/api/absen";
  var apidata, apidatasiswa;
  var pelajaran, datapelajaran;
  var response, responsesiswa;
  var kelas, siswa, countsiswa;
  Map<int, String> radioItem = new Map<int, String>();
  var datasiswa, idmapel;
  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = "";

  @override
  void initState() {
    getPref();
    super.initState();
  }

  getPref() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getString("login");
    if (islogin != null) {
      idmapel = pref.getString("mapelid")!;
      response = await dio.get(url);
      apidata = response.data;
      datapelajaran =
          apidata['data'].where((o) => o['id_pelajaran'] == idmapel).toList();
      pelajaran = datapelajaran[0];

      kelas = pref.getString("kelas")!;
      responsesiswa = await dio.get(urlsiswa);
      apidatasiswa = responsesiswa.data;
      datasiswa = apidatasiswa['data']
          .where((o) =>
              o['id_siswa'] == pref.getString('idlogin') &&
              o['id_pelajaran'] == idmapel)
          .toList();

      countsiswa =
          apidatasiswa['data'].where((o) => o['kode_kelas'] == kelas).length;

      if (apidatasiswa['data'] == null || datasiswa.length < 1) {
        error = true;
        errmsg = "Data Tidak ada !";
      }
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
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int no = 0;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (pelajaran != null) {
              return Column(
                children: <Widget>[
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.center,
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
                                    "Absensi",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 172, 43, 43)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    color: Color.fromARGB(255, 172, 43, 43),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromARGB(66, 2, 0, 0),
                      ), //<-- SEE HERE
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10, top: 10),
                              child: Text(
                                'No',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 40, right: 25, bottom: 10, top: 10),
                              child: Text(
                                'Tanggal',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 25, right: 40, top: 10, bottom: 10),
                              child: Text(
                                'Keterangan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            )
                          ],
                        ),
                        Container(
                          color: Color.fromARGB(255, 0, 0, 0),
                          height: 1,
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
                                ? Text("Data Tidak Ada !")
                                : ListView(
                                    //if everything fine, show the JSON as widget
                                    children: datasiswa.map<Widget>((siswa) {
                                      no += 1;
                                      Color color = Color(1);
                                      if (siswa['status'] == 'Hadir') {
                                        color =
                                            Color.fromARGB(255, 145, 247, 177);
                                      }
                                      if (siswa['status'] == 'Izin') {
                                        color =
                                            Color.fromARGB(255, 93, 232, 245);
                                      }
                                      if (siswa['status'] == 'Sakit') {
                                        color =
                                            Color.fromARGB(255, 245, 227, 93);
                                      }
                                      if (siswa['status'] == 'Tidak Hadir') {
                                        color =
                                            Color.fromARGB(255, 245, 93, 93);
                                      }
                                      return Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color:
                                                  Color.fromARGB(66, 2, 0, 0),
                                            ), //<-- SEE HERE
                                          ),
                                          margin: EdgeInsets.only(
                                              left: 25, right: 25),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                          left: 15,
                                                        ),
                                                        child:
                                                            Text(no.toString()),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin:
                                                            EdgeInsets.only(),
                                                        child:
                                                            Text(siswa['tgl']),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            right: 50,
                                                            top: 3,
                                                            bottom: 3),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          color: color,
                                                          child: Text(
                                                            siswa['status'],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                    }).toList(),
                                  )),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
        ));
  }
}
