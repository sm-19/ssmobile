// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/informasi_controller.dart';
import 'package:dio/dio.dart';

class InformasiView extends GetView<InformasiController> {
  const InformasiView({Key? key}) : super(key: key);

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
    String url = "https://www.tampilan.sekolahpintar.my.id/Api/api/pengumuman";
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
                            "Pengumuman",
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
                                children:
                                    apidata['data'].map<Widget>((pengumuman) {
                                  return InkWell(
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 60, 151, 144),
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
                                                  "assets/gambar/pengumuman.png",
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
                                                        pengumuman['judul'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        pengumuman['detail'],
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
                                        var judul = pengumuman['judul'];
                                        var isi = pengumuman['detail'];
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildAboutDialog(
                                                  context, judul, isi),
                                        );
                                        // Perform some action
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

Widget _buildAboutDialog(BuildContext context, var judul, var isi) {
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
