// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/document_types.dart';
import 'package:vehicles_app/screens/login_screen.dart';
import 'package:vehicles_app/screens/procedures_screen.dart';
import 'package:vehicles_app/screens/vehicle_type_screen.dart';
import 'package:vehicles_app/screens/vehicle_types_screen.dart';
import 'brands_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  // ignore: use_key_in_widget_constructors
  const HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: _getBody(),
      drawer: widget.token.user.userType == 0
          ? _getMechanicMenu()
          : _getCustomerMenu(),
    );
  }

  Widget _getBody() {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(140),
            child: FadeInImage(
                placeholder: const AssetImage('assets/Vehicles_Logos.png'),
                image: NetworkImage(widget.token.user.imageFullPath),
                height: 280,
                fit: BoxFit.cover),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Bienvenid@ ${widget.token.user.fullName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _getMechanicMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              child: Image(
            image: AssetImage('assets/Vehicles_Logos.png'),
          )),
          ListTile(
              leading: const Icon(Icons.two_wheeler),
              title: const Text('Marcas'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BrandsScreen(
                              token: widget.token,
                            )));
              }),
          ListTile(
              leading: const Icon(Icons.precision_manufacturing),
              title: const Text('Procedimientos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProceduresScreen(
                              token: widget.token,
                            )));
              }),
          ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Tipos de Documento'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DocumentTypesScreen(
                              token: widget.token,
                            )));
              }),
          ListTile(
              leading: const Icon(Icons.toys),
              title: const Text('Tipos de Vehículos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VehicleTypesScreen(
                              token: widget.token,
                            )));
              }),
          ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Usuarios'),
              onTap: () {}),
          const Divider(
            color: Colors.black,
            height: 2,
          ),
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text('Editar Perfil'),
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }),
        ],
      ),
    );
  }

  Widget _getCustomerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              child: Image(
            image: AssetImage('assets/Vehicles_Logos.png'),
          )),
          ListTile(
            leading: const Icon(Icons.two_wheeler),
            title: const Text('Mis Vehiculos'),
            onTap: () {},
          ),
          const Divider(
            color: Colors.black,
            height: 2,
          ),
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text('Editar Perfil'),
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }),
        ],
      ),
    );
  }
}
