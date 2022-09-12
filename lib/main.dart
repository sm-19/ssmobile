import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'app/widget/splash.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

var islogin;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getPref();
    super.initState();
  }

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('login') != null) {
      islogin = pref.getString('login')!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return splash();
          } else {
            if (islogin == 'guru' || islogin == 'siswa') {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: Routes.DASHBOARD,
                getPages: AppPages.routes,
              );
            } else {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: Routes.LOGIN,
                getPages: AppPages.routes,
              );
            }
          }
        });
  }
}
