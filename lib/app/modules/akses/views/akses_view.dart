// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartschool/app/modules/absensiguru/views/absensiguru_view.dart';
import '../controllers/akses_controller.dart';
import 'package:dio/dio.dart';

class AksesView extends GetView<AksesController> {
  const AksesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformasiListState();
  }
}

class InformasiListState extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InformasiListState> {
  var response;
  Dio dio = Dio();
  bool error = false;
  bool loading = false;
  String errmsg = "";
  var apidata, dataabsen;
  String login = '';
  var kk, np, idkelas, idmapel;
  getData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    login = pref.getString("login")!;
    kk = pref.getString("kelas")!;
    np = pref.getString("mapelnama")!;
    idkelas = pref.getString("idkelas")!;
    idmapel = pref.getString("mapelid")!;
    String url =
        "https://www.tampilan.sekolahpintar.my.id/Api/api/daftar_absen";
    var response = await dio.get(url);
    apidata = response.data;
    if (apidata['data'] != null) {
      dataabsen = apidata['data']
          .where((o) =>
              o['id_guru'] == pref.getString('idlogin') &&
              o['id_pelajaran'] == pref.getString('mapelid'))
          .toList();
    }

    if (apidata['data'] == null || dataabsen.length < 1) {
      error = true;
      errmsg = "Data Tidak ada !";
    }

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

  DateTime selectedDate = DateTime.now();

//  Initial SelectDate FLutter

  showAlertDialog(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        Future<Null> _selectDate() async {
          // Initial DateTime FIinal Picked
          final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2015, 8),
              lastDate: DateTime(2101));
          if (picked != null && picked != selectedDate)
            setState(() {
              selectedDate = picked;
              Navigator.of(context1).pop();
              showAlertDialog(selectedDate);
            });
        }

        return AlertDialog(
          title: (Text("Tambah Absen")),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mapel"),
                      Text("Kelas"),
                      Container(
                        child: Text(
                          "Tanggal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        margin: EdgeInsets.only(top: 10),
                      ),
                      Text("${selectedDate.toLocal()}".split(' ')[0]),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(' : '),
                        Text(np),
                      ]),
                      Row(children: [
                        Text(' : '),
                        Text(kk),
                      ]),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 16.0,
                ),
                label: const Text('Pilih Tanggal'),
                onPressed: () {
                  _selectDate();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 82, 106, 118),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              )
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
                await http.post(
                    Uri.parse(
                        "https://www.tampilan.sekolahpintar.my.id/Api/api/tambah_daftar_absen"),
                    body: {
                      "id_kelas": idkelas,
                      "id_pelajaran": idmapel,
                      "tgl": "${selectedDate.toLocal()}".split(' ')[0],
                      "status": 'Belum Selesai'
                    });
                Navigator.of(context1).pop();
                getData();
                showDialog(
                  context: context,
                  builder: (BuildContext context5) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context5).pop(true);
                    });
                    return AlertDialog(
                      title: Icon(
                        Icons.check,
                        size: 40,
                        color: Color.fromARGB(255, 39, 247, 167),
                      ),
                      content: Text(
                        "Berhasil Tambah Absen",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  hapusabsen(id) async {
    showDialog(
      context: context,
      builder: (BuildContext context5) {
        return AlertDialog(
          title: Icon(
            Icons.check,
            size: 40,
            color: Color.fromARGB(255, 39, 247, 167),
          ),
          content: Text(
            "Ingin menghapus absen ?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context5).pop();
              },
            ),
            TextButton(
              child: Text("iya"),
              onPressed: () async {
                await http.post(
                    Uri.parse(
                        "https://www.tampilan.sekolahpintar.my.id/Api/api/hapus_absen"),
                    body: {
                      "id": id,
                    });
                Navigator.of(context5).pop();
              },
            )
          ],
        );
      },
    );
  }

  listabsen() {
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          child: loading
              ? CircularProgressIndicator()
              : error
                  ? Text("$errmsg")
                  : ListView(
                      //if everything fine, show the JSON as widget
                      children: dataabsen.map<Widget>((absen) {
                        return InkWell(
                            child: Card(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/gambar/Study.png",
                                            width: 40.0,
                                            height: 40.0,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Absensi',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                absen['tgl'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                          child: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Color.fromARGB(
                                                255, 196, 51, 51),
                                          ),
                                          onTap: () {
                                            hapusabsen(absen['id']);
                                          }),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              pertemuanSession(absen['id']);
                            });
                      }).toList(),
                    )),
    );
  }

  @override
  initState() {
    getData();
    listabsen();
    super.initState();
  }

  pertemuanSession(idabsen) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("idabsen", idabsen);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AbsensiguruView()));
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(np.toString(),
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 20)),
                          ],
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
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: RaisedButton(
                        padding: EdgeInsets.all(2),
                        color: Color.fromARGB(255, 57, 206, 154),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Color.fromARGB(235, 255, 255, 255),
                              size: 16,
                            ),
                            Text(
                              "Tambah",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showAlertDialog(selectedDate);
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: RaisedButton(
                        padding: EdgeInsets.all(2),
                        color: Color.fromARGB(255, 85, 184, 226),
                        child: Row(
                          children: [
                            Icon(
                              Icons.print,
                              color: Color.fromARGB(235, 255, 255, 255),
                              size: 16,
                            ),
                            Text(
                              " Print",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showAlertDialog(selectedDate);
                        }),
                  ),
                ],
              ),
              listabsen(),
            ],
          );
        })),
      ),
    );
  }
}
