import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smartschool/app/modules/dashboard/views/dashboard_view.dart';
import '../controllers/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  Widget build(BuildContext context) {
    return LoginListState();
  }
}

class LoginListState extends StatefulWidget {
  _LoginViewState createState() => _LoginViewState();
}

class HeadClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LoginViewState extends State<LoginListState> {
  @override
  void initState() {
    ceckLogin();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditNISN = TextEditingController();
  var txtEditPwd = TextEditingController();
  var radioItem;
  var output;

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Smart',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 79, 240, 255)),
          children: [
            TextSpan(
              text: 'School',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 253, 77, 77),
                  fontSize: 30),
            ),
          ]),
    );
  }

  Widget akses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          activeColor: Color.fromARGB(255, 248, 248, 248),
          groupValue: radioItem,
          value: 'guru',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        new Text(
          'Guru',
          style: new TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        new Radio(
          activeColor: Color.fromARGB(255, 248, 248, 248),
          groupValue: radioItem,
          value: 'siswa',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        new Text(
          'Siswa',
          style: new TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        new Radio(
          activeColor: Color.fromARGB(255, 248, 248, 248),
          groupValue: radioItem,
          value: 'orangtua',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        new Text(
          'Orang Tua',
          style: new TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ],
    );
  }

  Widget inputNISN() {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'NISN harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEditNISN,
      onSaved: (String? val) {
        txtEditNISN.text = val!;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan NISN.NIP',
        hintStyle: const TextStyle(color: Colors.white),
        labelText: "Masukkan NISN/NIP",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  Widget inputPassword() {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: true, //make decript inputan
      validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'Password harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEditPwd,
      onSaved: (String? val) {
        txtEditPwd.text = val!;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Password',
        hintStyle: const TextStyle(color: Colors.white),
        labelText: "Masukkan Password",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      if (radioItem != null) {
        _formKey.currentState!.save();
        doLogin(txtEditNISN.text, txtEditPwd.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "Pilih login sebagai dulu !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          )),
        );
      }
    }
  }

  doLogin(NISN, password) async {
    try {
      var response;
      if (radioItem == "guru") {
        response = await http.post(
            Uri.parse("https://www.tampilan.sekolahpintar.my.id/Api/api/login"),
            body: {"nip": NISN, "password": password});
      }
      if (radioItem == "siswa") {
        response = await http.post(
            Uri.parse(
                "https://www.tampilan.sekolahpintar.my.id/Api/api/login_siswa"),
            body: {"nisn": NISN, "password": password});
      }
      output = jsonDecode(response.body);
      final output2 = output['login'];

      if (response.statusCode == 200 && output['pesan'] == "sukses login") {
        if (radioItem == "guru") {
          final namaguru = output2[0]['nama_guru'];
          final idlogin = output2[0]['id_guru'];
          final kelas = '';
          saveSession(idlogin, namaguru, NISN, kelas);
        }
        if (radioItem == "siswa") {
          final namasiswa = output2[0]['nama_siswa'];
          final idlogin = output2[0]['id_siswa'];
          final kelas = output2[0]['kode_kelas'];
          saveSession(idlogin, namasiswa, NISN, kelas);
        }
      } else {
        showAlertDialog();
      }
    } catch (e) {}
  }

  showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.dangerous_outlined,
            size: 40,
            color: Color.fromARGB(255, 247, 39, 39),
          ),
          content: Text(
            output['pesan'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void saveSession(idlogin, nama, nisn, kelas) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("idlogin", idlogin);
    await pref.setString("nisn", nisn);
    await pref.setString("nama", nama);
    await pref.setString("login", radioItem);
    if (radioItem == 'siswa') {
      await pref.setString("kelas", kelas);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

  void ceckLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getString("login");
    if (islogin == 'guru' || islogin == 'siswa') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Dashboard(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 48, 148, 163),
            Color.fromARGB(255, 57, 200, 195)
          ],
        )),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ClipPath(
                clipper: HeadClipper(),
                child: Container(
                    width: double.infinity,
                    height: 180,
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/gambar/logosd.png",
                          height: 100,
                        ),
                      ],
                    )),
              ),
              Column(
                children: [
                  _title(),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Login Sebagai :",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      akses(),
                      const SizedBox(height: 20.0),
                      inputNISN(),
                      const SizedBox(height: 20.0),
                      inputPassword(),
                      const SizedBox(height: 5.0),
                    ],
                  )),
              Container(
                padding:
                    const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 53, 187, 122),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              color: Color.fromARGB(53, 255, 255, 255)),
                        ),
                        elevation: 10,
                        minimumSize: const Size(200, 58)),
                    onPressed: () => _validateInputs(),
                    icon: const Icon(Icons.arrow_right_alt),
                    label: const Text(
                      "LOG IN",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
