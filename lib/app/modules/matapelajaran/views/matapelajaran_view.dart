import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var response;
  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  var apidata; //for decoded JSON data

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    String url = "https://www.sekolahpintar.my.id/Api/api/pelajaran";
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
  Widget build(BuildContext context) {
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
                    Text("MATA PELAJARAN",
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
                                              child: Column(children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      mapel['pelajaran'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      mapel['nama_pelajaran'],
                                                    )
                                                  ],
                                                )
                                              ]),
                                            ),
                                          )),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeView(
                                                    mapel: mapel[
                                                        'nama_pelajaran'])));
                                      },
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
