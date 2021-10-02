// ignore_for_file: unused_field

// ignore: import_of_legacy_library_into_null_safe
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ignore: prefer_final_fields
  String _email = '';
  // ignore: prefer_final_fields
  String _emailError = '';
  // ignore: prefer_final_fields
  bool _emailShowError = false;
  String _password = '';
  // ignore: prefer_final_fields
  bool _rememberme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showLogo(),
          const SizedBox(
            height: 20,
          ),
          _showEmail(),
          _showPassword(),
          _showRememberme(),
          _showButtons(),
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

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa tu email.....',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
          // ignore: avoid_print
          print(_email);
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Ingresa tu contraseña...',
          labelText: 'Contraseña',
          suffixIcon: const Icon(Icons.lock),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showRememberme() {
    return CheckboxListTile(
      title: const Text('Recordarme'),
      value: _rememberme,
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: const Text('Iniciar sesión'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color(0xFF120E43);
                }),
              ),
              onPressed: () => _login(),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              child: const Text('Nuevo usuario'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color(0xFF03203C);
                }),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    if (!_validateFields()) {
      return;
    }
  }

  bool _validateFields() {
    bool hasErrors = false;

    if (_email.isEmpty) {
      hasErrors = true;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu email.';
    } else if (!EmailValidator.validate(_email)) {
      hasErrors = true;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email válido.';
    } else {
      _emailShowError = false;
    }
    setState(() {});
    return hasErrors;
  }
}
