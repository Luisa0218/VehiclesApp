import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showLogo(),
        ],
      )),
    );
  }

  Widget _showLogo() {
    return const Image(
      // ignore: unnecessary_string_escapes
      image: AssetImage('assets/Vehicles_Logos.png'),
      width: 300,
    );
  }
}
