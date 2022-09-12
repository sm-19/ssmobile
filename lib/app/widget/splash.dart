import 'package:flutter/material.dart';

class splash extends StatelessWidget {
  const splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/gambar/logosd.png",
                  width: 200.0,
                  height: 150.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 54.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Smart",
                    style: TextStyle(
                      color: Color.fromARGB(255, 27, 228, 221),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  const Text(
                    "School",
                    style: TextStyle(
                      color: Color.fromARGB(255, 217, 67, 67),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
