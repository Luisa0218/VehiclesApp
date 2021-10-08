import 'package:flutter/material.dart';
import 'package:vehicles_app/models/token.dart';

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
      drawer: _getMechanicMenu(),
    );
  }

  Widget _getBody() {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Center(
        child: Text(
          'Bienvenid@ ${widget.token.user.fullName}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(Icons.precision_manufacturing),
              title: const Text('Procedimientos'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Tipos de Documento'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.toys),
              title: const Text('Tipos de Vehículos'),
              onTap: () {}),
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
              onTap: () {}),
        ],
      ),
    );
  }
}
