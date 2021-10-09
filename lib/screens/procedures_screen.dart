// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, unused_field, avoid_print, prefer_is_empty, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vehicles_app/components/loader_component.dart';

import 'package:vehicles_app/helpers/constans%20.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/token.dart';

class ProceduresScreen extends StatefulWidget {
  final Token token;

  const ProceduresScreen({required this.token});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Procedure> _procedures = [];

  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getProcedures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimientos'),
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'por favor espere...')
            : getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  void _getProcedures() async {
    setState(() {
      _showLoader = true;
    });
    var url = Uri.parse('${Constans.apiUrl}/api/Procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
    );
    setState(() {
      _showLoader = false;
    });

    var body = response.body;
    var decodeJson = jsonDecode(body);
    if (decodeJson != null) {
      for (var item in decodeJson) {
        _procedures.add(Procedure.fromJson(item));
      }
    }
    print(_procedures);
  }

  Widget getContent() {
    return _procedures.length == 0 ? noContent() : _getListView();
  }

  Widget noContent() {
    // ignore: prefer_const_constructors
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text('No hay procedimientos almacenados',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      children: _procedures.map((e) {
        return Card(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        // ignore: unnecessary_string_interpolations
                        '${NumberFormat.currency(symbol: '\$').format(e.price)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
