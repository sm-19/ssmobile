import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/raport_controller.dart';

// ignore: must_be_immutable
class RaportView extends GetView<RaportController> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            Column(
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
                                  color: Color.fromARGB(179, 0, 0, 0),
                                  blurRadius: 1,
                                )
                              ],
                            ),
                            child: Text(
                              "Raport",
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
            ),
          ],
        ),
      ),
    );
  }
}
