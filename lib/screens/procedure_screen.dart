// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, prefer_final_fields, duplicate_ignore, unused_field

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';

import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';

class ProcedureScreen extends StatefulWidget {
  final Token token;
  final Procedure procedure;

  const ProcedureScreen({required this.token, required this.procedure});

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

// ignore: duplicate_ignore
class _ProcedureScreenState extends State<ProcedureScreen> {
  bool _showLoader = false;
  // ignore: prefer_final_fields
  String _description = '';
  // ignore: unused_field
  String _descriptionError = '';
  bool _descriptionShowError = false;
  // ignore: unused_field
  TextEditingController _descriptionController = TextEditingController();

  // ignore: prefer_final_fields
  String _price = '';
  // ignore: unused_field
  String _priceError = '';
  bool _priceShowError = false;
  // ignore: unused_field
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _description = widget.procedure.description;
    _descriptionController.text = _description;
    _price = widget.procedure.price.toString();
    _priceController.text = _price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.id == 0
            ? 'Nuevo procedimiento'
            : widget.procedure.description),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showDescription(),
              _showPrice(),
              _showButtons(),
            ],
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        autofocus: true,
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa una descripcion.....',
          labelText: 'Descripcion',
          errorText: _descriptionShowError ? _descriptionError : null,
          suffixIcon: const Icon(Icons.description),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }

  Widget _showPrice() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _priceController,
        decoration: InputDecoration(
          hintText: 'Ingresa un precio.....',
          labelText: 'Precio',
          errorText: _priceShowError ? _priceError : null,
          suffixIcon: const Icon(Icons.attach_money),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _price = value;
        },
      ),
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
              child: const Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color(0xFF120E43);
                }),
              ),
              onPressed: () => _save(),
            ),
          ),
          widget.procedure.id == 0
              ? Container()
              : const SizedBox(
                  width: 20,
                ),
          widget.procedure.id == 0
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                    child: const Text('Borrar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return const Color(0xFFB4161B);
                      }),
                    ),
                    onPressed: () => _confirmDelete(),
                  ),
                ),
        ],
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }
    widget.procedure.id == 0 ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_description.isEmpty) {
      isValid = false;
      _descriptionShowError = true;
      _descriptionError = 'Debes ingresar una descripción.';
    } else {
      _descriptionShowError = false;
    }

    if (_price.isEmpty) {
      isValid = false;
      _priceShowError = true;
      _priceError = 'Debes ingresar un precio';
    } else {
      double price = double.parse(_price);
      if (price <= 0) {
        isValid = false;
        _priceShowError = true;
        _priceError = 'Debes ingresar un precio mayor a cero.';
      } else {
        _priceShowError = false;
      }
    }

    setState(() {});
    return isValid;
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });
    Map<String, dynamic> request = {
      'description': _description,
      'price': double.parse(_price),
    };

    Response response =
        await ApiHelper.post('/api/Procedures/', request, widget.token.token);

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

    Navigator.pop(context, 'yes');
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id': widget.procedure.id,
      'description': _description,
      'price': double.parse(_price),
    };

    Response response = await ApiHelper.put('/api/Procedures/',
        widget.procedure.id.toString(), request, widget.token.token);

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

    Navigator.pop(context, 'yes');
  }

  void _confirmDelete() async {
    // ignore: unused_local_variable
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿Estas seguro de querer borrar el registro?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'No'),
          const AlertDialogAction(key: 'yes', label: 'Sí'),
        ]);

    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });
    Response response = await ApiHelper.delete(
        '/api/Procedures/', widget.procedure.id.toString(), widget.token.token);

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

    Navigator.pop(context, 'yes');
  }
}
