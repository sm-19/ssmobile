// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/views/login_view.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MapelListState();
  }
}

class MapelListState extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapelListState> {
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  var apidata;
  var siswa, datasiswa;
  var response, response2;
  var idsiswa, output;
  String islogin = '';
  String url = '';
  String data = '';
  String ni = '';
  String nama = '';
  String hp = '';

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    islogin = pref.getString("login")!;
    if (islogin == 'siswa') {
      url = "https://www.tampilan.sekolahpintar.my.id/Api/api/siswa";
      data = 'id_siswa';
      ni = 'nisn';
      nama = 'nama_siswa';
      hp = 'hp';
    }
    if (islogin == 'guru') {
      url = "https://www.tampilan.sekolahpintar.my.id/Api/api/guru";
      data = 'id_guru';
      ni = 'nip';
      nama = 'nama_guru';
      hp = 'no_hp';
    }
    // ignore: unnecessary_null_comparison
    if (islogin != null) {
      idsiswa = pref.getString("idlogin")!;
      response = await dio.get(url);
      apidata = response.data;
      datasiswa = apidata['data'].where((o) => o[data] == idsiswa).toList();
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
    setState(() {});
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  ubahguru(password, idsiswa, BuildContext context1) async {
    try {
      final response2 = await http.post(
          Uri.parse(
              "https://www.tampilan.sekolahpintar.my.id/Api/api/ubah_guru"),
          body: {"password": password, "" + data: idsiswa});
      output = jsonDecode(response2.body);
      Navigator.of(context1).pop();
      showAlertDialog();
    } catch (e) {}
  }

  ubahsiswa(password, idsiswa, BuildContext context1) async {
    try {
      final response2 = await http.post(
          Uri.parse(
              "https://www.tampilan.sekolahpintar.my.id/Api/api/ubah_siswa"),
          body: {"password": password, "" + data: idsiswa});
      output = jsonDecode(response2.body);
      Navigator.of(context1).pop();
      showAlertDialog();
    } catch (e) {}
  }

  showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Icon(
            Icons.check,
            size: 40,
            color: Color.fromARGB(255, 39, 247, 195),
          ),
          content: Text(
            output['pesan'].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context2).pop();
                getPref();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var txtEditPwd = TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Stack(children: [
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (siswa != null) {
                return ListView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  "Profil",
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
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 80, left: 40, right: 40),
                                      height: 100,
                                      decoration: new BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                179, 224, 119, 119),
                                            blurRadius: 4,
                                          )
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          islogin == 'siswa'
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  height: 100,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        blurRadius: 2,
                                                      )
                                                    ],
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: Image.network(
                                                                'https://www.tampilan.sekolahpintar.my.id/assets/img/data/' +
                                                                    siswa[
                                                                        'img_siswa'])
                                                            .image),
                                                  ),
                                                )
                                              : Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  height: 100,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        blurRadius: 2,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(height: 5),
                                          Text(
                                            siswa[nama],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          islogin == 'guru'
                                              ? Text("NIP : " + siswa[ni])
                                              : Text("NISN : " + siswa[ni]),
                                          islogin == 'siswa'
                                              ? Text("Kelas : " +
                                                  siswa['kode_kelas'])
                                              : Text('')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 40, top: 20, bottom: 20),
                              margin:
                                  EdgeInsets.only(top: 20, left: 40, right: 40),
                              decoration: new BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(179, 224, 119, 119),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.phone, size: 20),
                                      SizedBox(width: 10),
                                      Text(siswa[hp]),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 20),
                                      SizedBox(width: 12),
                                      Text(siswa['alamat']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.lock, size: 20),
                                      SizedBox(width: 10),
                                      Text(siswa['password']),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Center(
                                child: RaisedButton(
                                  color: Color.fromARGB(255, 57, 206, 154),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context1) {
                                          return AlertDialog(
                                            content: Stack(
                                              clipBehavior: Clip.none,
                                              children: <Widget>[
                                                Positioned(
                                                  right: -40.0,
                                                  top: -40.0,
                                                  child: InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context1)
                                                          .pop();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.close),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "UBAH PASSWORD",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(height: 20),
                                                      TextFormField(
                                                        controller: txtEditPwd,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                "Password",
                                                            border:
                                                                OutlineInputBorder()),
                                                        validator:
                                                            (String? arg) {
                                                          if (arg == null ||
                                                              arg.isEmpty) {
                                                            return 'NISN harus diisi';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                      RaisedButton(
                                                          color: Color.fromARGB(
                                                              255,
                                                              57,
                                                              206,
                                                              154),
                                                          child: Text(
                                                            "Ubah",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255)),
                                                          ),
                                                          onPressed: () {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              islogin == 'siswa'
                                                                  ? ubahsiswa(
                                                                      txtEditPwd
                                                                          .text,
                                                                      siswa[
                                                                          'id_siswa'],
                                                                      context1)
                                                                  : islogin ==
                                                                          'guru'
                                                                      ? ubahguru(
                                                                          txtEditPwd
                                                                              .text,
                                                                          siswa[
                                                                              'id_guru'],
                                                                          context1)
                                                                      : Container();
                                                            }
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Ubah Password",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          )
        ])),
      ),
    );
  }
}
