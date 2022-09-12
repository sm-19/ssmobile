// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/login/views/login_view.dart';
import 'package:smartschool/main.dart';
import '../controllers/materi_controller.dart';

// ignore: must_be_immutable
class MateriView extends GetView<MateriController> {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String txtNama = "";
  String txtMulai = "";
  String txtSelesai = "";
  String txtTgl = "";

  var txtEditNama = TextEditingController();
  var txtDate = TextEditingController();
  var txtFilePicker = TextEditingController();
  DateTime date = DateTime.now();

  File? filePickerVal;

  Dio dio = Dio();
  var res;
  String progress = '';
  String url =
      "https://www.tampilan.sekolahpintar.my.id/Api/api/jadwal_pelajaran";
  String urlmateri = "https://www.tampilan.sekolahpintar.my.id/Api/api/materi";
  var apidata, apidatamateri;
  var pelajaran, datamateri, datapelajaran;
  var response, responsemateri;
  var idsiswa, idkelas, idmapel;
  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = "";

  //upload file

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
    idmapel = pref.getString('mapelid');
    if (islogin != null) {
      idsiswa = pref.getString("kelas")!;
      response = await dio.get(url);
      apidata = response.data;
      datapelajaran = apidata['data']
          .where(
              (o) => o['kode_kelas'] == idsiswa && o['id_pelajaran'] == idmapel)
          .toList();
      pelajaran = datapelajaran[0];

      responsemateri = await dio.get(urlmateri);
      apidatamateri = responsemateri.data;
      datamateri = apidatamateri['data']
          .where((o) => o['id_pelajaran'] == idmapel)
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

  Widget buildFilePicker() {
    return Row(
      children: [
        ElevatedButton.icon(
          icon: const Icon(
            Icons.upload_file,
            color: Colors.white,
            size: 16.0,
          ),
          label: const Text('Pilih File'),
          onPressed: () {
            selectFile();
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 82, 106, 118),
            minimumSize: const Size(122, 48),
            maximumSize: const Size(122, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextFormField(
              readOnly: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'File harus diupload';
                } else {
                  return null;
                }
              },
              controller: txtFilePicker),
        ),
      ],
    );
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['doc', 'pdf']);
    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        filePickerVal = File(result.files.single.path.toString());
      });
    } else {
      // User canceled the picker
    }
  }

  void _validateInputs(ip, ik, context1) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      simpan(ip, ik, context1);
    }
  }

  simpan(ip, ik, context1) async {
    final String nama = txtEditNama.text;

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://www.tampilan.sekolahpintar.my.id/Api/api/tambah_materi'));

      request.headers.addAll(headers);
      request.fields['id_pelajaran'] = ip;
      request.fields['id_kelas'] = ik;
      request.fields['nama_materi'] = nama;

      request.files.add(http.MultipartFile('file_materi',
          filePickerVal!.readAsBytes().asStream(), filePickerVal!.lengthSync(),
          filename: filePickerVal!.path.split("/").last));
      print(filePickerVal!.readAsBytes().asStream());
      print(filePickerVal!.lengthSync());

      var res = await request.send();
      var responseBytes = await res.stream.toBytes();
      var responseString = utf8.decode(responseBytes);
      //debug
      print("response byte: " + responseBytes.toString());
      print("response: " + responseString.toString());

      if (res.statusCode == 200) {
        getPref();
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!99u
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("Berhasil Tambah Materi"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: false).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {}
    } catch (e) {
      debugPrint('$e');
    }
  }

  convertDateFromString(String strDate) {
    DateTime date = DateTime.parse(strDate);
    return DateFormat("dd/MM/yyyy").format(date);
  }

  showAlertDialog(ip, ik) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: (Text("Tambah Materi")),
          content: ListView(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nama File",
                              style: TextStyle(fontSize: 16.0)),
                        ),
                        TextFormField(
                            key: Key(txtNama),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama file harus diisi';
                              } else {
                                return null;
                              }
                            },
                            controller: txtEditNama,
                            onSaved: (String? val) {
                              txtEditNama.text = val!;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              hintText: 'Nama file',
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            style: const TextStyle(fontSize: 16.0)),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Browse File",
                              style: TextStyle(fontSize: 16.0)),
                        ),
                        buildFilePicker()
                      ]))
            ],
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context1).pop();
              },
            ),
            TextButton(
              child: Text("Tambah"),
              onPressed: () async {
                _validateInputs(ip, ik, context1);
              },
            ),
          ],
        );
      },
    );
  }

  uploadFile() async {
    String uploadurl =
        "https://www.tampilan.sekolahpintar.my.id/Api/api/tambah_materi";

    response = await dio.post(
      uploadurl,
      data: {"id_pelajaran": idmapel, "id_kelas": idkelas, "nama_materi": ''},
    );

    if (response.statusCode == 200) {
      print(response.toString());
    } else {
      print("Error during connection to server.");
    }
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
            FutureBuilder(builder:
                (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (pelajaran != null && islogin == 'guru') {
                return Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10),
                  child: RaisedButton(
                      padding: EdgeInsets.all(2),
                      color: Color.fromARGB(255, 57, 206, 154),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Color.fromARGB(235, 255, 255, 255),
                          ),
                          Text(
                            "Tambah Materi",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ],
                      ),
                      onPressed: () {
                        showAlertDialog(idmapel, pelajaran['id_kelas']);
                      }),
                );
              } else {
                return Container();
              }
            }),
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
                                                      materi['nama_materi'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      materi['file_materi'],
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
                                    onTap: () {});
                              }).toList(),
                            )),
            ),
          ],
        ),
      ),
    );
  }
}
