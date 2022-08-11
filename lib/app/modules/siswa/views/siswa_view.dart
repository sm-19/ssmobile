import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final List<Map<String, dynamic>> myList = [
    {
      "Nama": "Sulaiman Majid",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Ardean Raflian",
      "NISN": "123456789",
      "Foto": "assets/foto/f2.png"
    },
    {
      "Nama": "Dimas Prasedy",
      "NISN": "123456789",
      "Foto": "assets/foto/f3.jpg"
    },
    {
      "Nama": "Amar F. Tech",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Sulaiman Majid",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Ardean Raflian",
      "NISN": "123456789",
      "Foto": "assets/foto/f2.png"
    },
    {
      "Nama": "Dimas Prasedy",
      "NISN": "123456789",
      "Foto": "assets/foto/f3.jpg"
    },
    {
      "Nama": "Amar F. Tech",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Sulaiman Majid",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Ardean Raflian",
      "NISN": "123456789",
      "Foto": "assets/foto/f2.png"
    },
    {
      "Nama": "Dimas Prasedy",
      "NISN": "123456789",
      "Foto": "assets/foto/f3.jpg"
    },
    {
      "Nama": "Amar F. Tech",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Sulaiman Majid",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
    {
      "Nama": "Ardean Raflian",
      "NISN": "123456789",
      "Foto": "assets/foto/f2.png"
    },
    {
      "Nama": "Dimas Prasedy",
      "NISN": "123456789",
      "Foto": "assets/foto/f3.jpg"
    },
    {
      "Nama": "Amar F. Tech",
      "NISN": "123456789",
      "Foto": "assets/foto/f1.jpeg"
    },
  ];

  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    _foundUsers = myList;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = myList;
    } else {
      results = myList
          .where((user) =>
              user["Nama"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
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
                        bottomLeft: const Radius.circular(15),
                        bottomRight: const Radius.circular(15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("DAFTAR SISWA",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 25)),
                        Icon(Icons.home),
                      ],
                    ),
                    Text("MATEMATIKA",
                        style: new TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 15)),
                    Container(
                      color: Color.fromARGB(255, 0, 0, 3),
                      height: 1,
                      margin: EdgeInsets.only(top: 5),
                    ),
                    TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(28, 0, 0, 2),
                          labelText: 'Cari Siswa',
                          suffixIcon: Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _foundUsers.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) => Card(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            color: Color.fromARGB(255, 255, 255, 255),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 8, 100, 157),
                                    fontSize: 20),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 26,
                                        backgroundColor:
                                            Color.fromARGB(255, 8, 100, 157),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              "${_foundUsers[index]['Foto']}"),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_foundUsers[index]['Nama']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("${_foundUsers[index]['NISN']}")
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                              ),
                            )))
                    : const Text(
                        'Data Tidak Ada !',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
