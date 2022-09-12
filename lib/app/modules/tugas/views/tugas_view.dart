// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import '../controllers/tugas_controller.dart';

// ignore: must_be_immutable
class TugasView extends GetView<TugasController> {
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
  String urlmateri = "https://www.tampilan.sekolahpintar.my.id/Api/api/tugas";
  var apidata, apidatamateri;
  var pelajaran, datamateri, datapelajaran;
  var response, responsemateri;
  var idsiswa;
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
      idsiswa = pref.getString("kelas")!;
      response = await dio.get(url);
      apidata = response.data;
      datapelajaran = apidata['data']
          .where((o) =>
              o['kode_kelas'] == idsiswa &&
              o['id_pelajaran'] == pref.getString('mapelid'))
          .toList();
      pelajaran = datapelajaran[0];

      responsemateri = await dio.get(urlmateri);
      apidatamateri = responsemateri.data;
      datamateri = apidatamateri['data']
          .where((o) => o['id_pelajaran'] == pref.getString('mapelid'))
          .toList();
      if (apidatamateri['data'] == null || datamateri.length < 1) {
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
                                  "Materi",
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
              height: 20,
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: loading
                      ? CircularProgressIndicator()
                      : error
                          ? Text("$errmsg")
                          : ListView(
                              //if everything fine, show the JSON as widget
                              children: datamateri.map<Widget>((materi) {
                                var isi1 =
                                    'Deskrisi ini adalah tentang deskripsi tugas yang harus siswa kerjkan, silahkan kerjakan tugas ini dan dikumpulkan pada hari';
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      materi['nama_tugas'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      isi1,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    onTap: () {
                                      var judul = materi['nama_tugas'];
                                      var isi = isi1;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildAboutDialog(
                                                context, judul, isi),
                                      );
                                    });
                              }).toList(),
                            )),
            ),
          ],
        ),
      ),
    );
  }

  _buildAboutDialog(BuildContext context, judul, String isi) {
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
}
