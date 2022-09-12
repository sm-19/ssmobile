// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import '../controllers/absensiguru_controller.dart';

// ignore: must_be_immutable
class AbsensiguruView extends GetView<AbsensiguruController> {
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
  String urlsiswa = "https://www.tampilan.sekolahpintar.my.id/Api/api/absen";
  var apidata, apidatasiswa;
  var pelajaran, datapelajaran;
  var response, responsesiswa;
  var kelas, siswa, countsiswa;
  Map<int, String> radioItem = new Map<int, String>();
  var datasiswa, idmapel, idabsen;
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
      idabsen = pref.getString("idabsen")!;
      response = await dio.get(url);
      apidata = response.data;
      datapelajaran =
          apidata['data'].where((o) => o['id_pelajaran'] == idmapel).toList();
      pelajaran = datapelajaran[0];

      kelas = pref.getString("kelas")!;
      responsesiswa = await dio.get(urlsiswa);
      apidatasiswa = responsesiswa.data;
      datasiswa = apidatasiswa['data']
          .where((o) => o['role_absen'] == idabsen)
          .toList();
      print(idabsen);

      countsiswa =
          apidatasiswa['data'].where((o) => o['role_absen'] == idabsen).length;
      siswa = datasiswa[0];
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

  void absensi(Map<int, String> radioItem, countsiswa) {
    if (radioItem.length == countsiswa) {
      String pesan = 'Absensi Berhasil';
      IconData icon = Icons.check;
      Color color = Color.fromARGB(207, 76, 231, 130);
      showAlertDialog(context, pesan, icon, color);
    } else {
      int gagal = countsiswa - radioItem.length;
      String pesan =
          'Absensi Gagal : ' + gagal.toString() + ' siswa belum absen';
      IconData icon = Icons.dangerous;
      Color color = Color.fromARGB(207, 231, 84, 76);
      showAlertDialog(context, pesan, icon, color);
    }
  }

  showAlertDialog(
      BuildContext context, String pesan, IconData icon, Color color) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Icon(
        icon,
        size: 40,
        color: color,
      ),
      content: Text(
        pesan,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _RaBut(color, val, a, text, ss) {
      return Container(
        margin: EdgeInsets.only(left: 2, right: 2),
        child: siswa['status'] != null
            ? Column(
                children: [
                  new GFRadio(
                    type: GFRadioType.custom,
                    inactiveIcon: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    activeIcon: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    size: 15,
                    activeBgColor: color,
                    inactiveBorderColor: color,
                    activeBorderColor: color,
                    groupValue: ss,
                    value: val,
                    onChanged: (a) {},
                  ),
                ],
              )
            : Container(),
      );
    }

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
                              children: datasiswa.map<Widget>((siswa) {
                                int a = int.parse(siswa['id_siswa']);
                                return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color.fromARGB(113, 203, 78, 78),
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
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color.fromARGB(
                                                255, 8, 100, 157),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: siswa[
                                                          'img_siswa'] ==
                                                      ""
                                                  ? AssetImage(
                                                      "assets/foto/f1.jpeg")
                                                  : Image.network(
                                                          'https://www.tampilan.sekolahpintar.my.id/assets/img/data/' +
                                                              siswa[
                                                                  'img_siswa'])
                                                      .image,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  siswa['nama_siswa'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      siswa['nisn'],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        _RaBut(
                                                            Color.fromARGB(255,
                                                                92, 214, 161),
                                                            'Hadir',
                                                            a,
                                                            'H',
                                                            siswa['status']),
                                                        _RaBut(
                                                            Color.fromARGB(255,
                                                                120, 195, 236),
                                                            'Izin',
                                                            a,
                                                            'I',
                                                            siswa['status']),
                                                        _RaBut(
                                                            Color.fromARGB(255,
                                                                236, 232, 120),
                                                            'Sakit',
                                                            a,
                                                            'S',
                                                            siswa['status']),
                                                        _RaBut(
                                                            Color.fromARGB(255,
                                                                236, 120, 120),
                                                            'Alpa',
                                                            a,
                                                            'A',
                                                            siswa['status'])
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              }).toList(),
                            )),
            ),
            RaisedButton(
                color: Color.fromARGB(255, 57, 206, 154),
                child: Text(
                  "Absen",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                onPressed: () {
                  absensi(radioItem, countsiswa);
                })
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
