// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, prefer_final_fields, duplicate_ignore, unused_field

import 'package:flutter/material.dart';

import 'package:vehicles_app/models/procedure.dart';
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
  bool __priceShowError = false;
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
      body: Column(
        children: <Widget>[
          _showDescription(),
          _showPrice(),
          _showButtons(),
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
          errorText: _descriptionShowError ? _descriptionError : null,
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
              onPressed: () => {},
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
                    onPressed: () {},
                  ),
                ),
        ],
      ),
    );
  }
}
