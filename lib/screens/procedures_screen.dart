// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, unused_field, avoid_print, prefer_is_empty, avoid_unnecessary_containers, unused_import, unused_local_variable
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/procedure_screen.dart';

class ProceduresScreen extends StatefulWidget {
  final Token token;

  const ProceduresScreen({required this.token});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Procedure> _procedures = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

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
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: const Icon(Icons.filter_none))
              : IconButton(
                  onPressed: _showFilter, icon: const Icon(Icons.filter_alt))
        ],
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'por favor espere...')
            : getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProcedureScreen(
                        token: widget.token,
                        procedure: Procedure(description: '', id: 0, price: 0),
                      )));
        },
      ),
    );
  }

  void _getProcedures() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getProcedures(widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    setState(() {
      _procedures = response.result;
    });
  }

  Widget getContent() {
    return _procedures.length == 0 ? noContent() : _getListView();
  }

  Widget noContent() {
    // ignore: prefer_const_constructors
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
            _isFiltered
                ? 'No hay procedimientos con ese criterio de busqueda.'
                : 'No hay procedimientos registrados.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      children: _procedures.map((e) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProcedureScreen(
                            token: widget.token,
                            procedure: e,
                          )));
            },
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
                        style: const TextStyle(fontSize: 20),
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

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Filtrar Procedimientos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Escriba las primeras letras del procedimiento'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: 'Criterio de búsqueda...',
                      labelText: 'Buscar',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    _search = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Filtrar')),
            ],
          );
        });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getProcedures();
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<Procedure> filteredList = [];
    for (var procedure in _procedures) {
      if (procedure.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(procedure);
      }
    }

    setState(() {
      _procedures = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
}
