// ignore_for_file: prefer_final_fields, prefer_void_to_null, duplicate_ignore, import_of_legacy_library_into_null_safe, unused_field, prefer_is_empty, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/document%20_type.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/models/user.dart';
import 'package:vehicles_app/screens/take_picture_screen.dart';

class UserScreen extends StatefulWidget {
  final Token token;
  final User user;

  // ignore: use_key_in_widget_constructors
  const UserScreen({required this.token, required this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _showLoader = false;
  bool _PhotoChanged = false;
  late XFile _image;

  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;
  // ignore: prefer_final_fields
  TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  TextEditingController _lastNameController = TextEditingController();

  int _documentTypeId = 0;
  String _documenTypeIdError = '';
  bool _documenTypeIdShowError = false;
  List<DocumentType> _documentTypes = [];

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  TextEditingController _documentController = TextEditingController();

  String _address = '';
  String _addressError = '';
  bool _addressShowError = false;
  TextEditingController _addressController = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDocumentTypes();

    _firstName = widget.user.firstName;
    _firstNameController.text = _firstName;

    _lastName = widget.user.lastName;
    _lastNameController.text = _lastName;

    _documentTypeId = widget.user.documentType.id;

    _document = widget.user.document;
    _documentController.text = _document;

    _address = widget.user.address;
    _addressController.text = _address;

    _email = widget.user.email;
    _emailController.text = _email;

    _phoneNumber = widget.user.phoneNumber;
    _phoneNumberController.text = _phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.user.id.isEmpty ? 'Nuevo usuario' : widget.user.fullName),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showPhoto(),
                _showFirstName(),
                _showLastName(),
                _showDocumentType(),
                _showDocument(),
                _showEmail(),
                _showAddress(),
                _showPhoneNumber(),
                _showButtons(),
              ],
            ),
          ),
          _showLoader
              // ignore: prefer_const_constructors
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showFirstName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _firstNameController,
        decoration: InputDecoration(
          hintText: 'Ingresa nombres...',
          labelText: 'Nombres',
          errorText: _firstNameShowError ? _firstNameError : null,
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _firstName = value;
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
          widget.user.id.isEmpty
              ? Container()
              : const SizedBox(
                  width: 20,
                ),
          widget.user.id.isEmpty
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

    widget.user.id.isEmpty ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      isValid = false;
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar al menos un nombre.';
    } else {
      _firstNameShowError = false;
    }

    if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'Debes ingresar al menos un apellido.';
    } else {
      _lastNameShowError = false;
    }

    if (_documentTypeId == 0) {
      isValid = false;
      _documenTypeIdShowError = true;
      _documenTypeIdError = 'Debes ingresar un tipo de documento.';
    } else {
      _documenTypeIdShowError = false;
    }

    if (_document.isEmpty) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'Debes ingresar el n??mero de documento.';
    } else {
      _documentShowError = false;
    }

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email.';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email v??lido.';
    } else {
      _emailShowError = false;
    }

    if (_address.isEmpty) {
      isValid = false;
      _addressShowError = true;
      _addressError = 'Debes ingresar una direcci??n.';
    } else {
      _addressShowError = false;
    }

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar un tel??fono.';
    } else {
      _phoneNumberShowError = false;
    }
    setState(() {});
    return isValid;
  }

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64image = '';
    if (_PhotoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': _firstName,
      'lastName': _lastName,
      'documentTypeId': _documentTypeId,
      'document': _document,
      'email': _email,
      'userName': _email,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'image': base64image,
    };

    Response response =
        await ApiHelper.post('/api/Users/', request, widget.token);

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

    String base64image = '';
    if (_PhotoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'id': widget.user.id,
      'firstName': _firstName,
      'lastName': _lastName,
      'documentTypeId': _documentTypeId,
      'document': _document,
      'email': _email,
      'userName': _email,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'image': base64image,
    };

    Response response = await ApiHelper.put(
        '/api/Users/', widget.user.id, request, widget.token);

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
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmaci??n',
        message: '??Estas seguro de querer borrar el registro?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'No'),
          const AlertDialogAction(key: 'yes', label: 'S??'),
        ]);

    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });

    Response response =
        await ApiHelper.delete('/api/Users/', widget.user.id, widget.token);

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

  Widget _showPhoto() {
    return InkWell(
      onTap: () => _takePicture(),
      child: Stack(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: widget.user.id.isEmpty && !_PhotoChanged
              ? const Image(
                  image: AssetImage('assets/noimage.png'),
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: _PhotoChanged
                      ? Image.file(
                          File(_image.path),
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage(
                          placeholder:
                              const AssetImage('assets/Vehicles_Logos.png'),
                          image: NetworkImage(widget.user.imageFullPath),
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Positioned(
            bottom: 0,
            left: 100,
            child: InkWell(
              onTap: () => _takePicture(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.green[50],
                  height: 60,
                  width: 60,
                  child: const Icon(
                    Icons.photo_camera,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ),
            )),
      ]),
    );
  }

  Widget _showLastName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
          hintText: 'Ingresa apellidos..',
          labelText: 'Apellidos',
          errorText: _lastNameShowError ? _lastNameError : null,
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget _showDocumentType() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: _documentTypes.length == 0
            ? const Text('Cargando tipos de documento.....')
            : DropdownButtonFormField(
                items: _getComboDocumentTypes(),
                value: _documentTypeId,
                onChanged: (option) {
                  setState(() {
                    _documentTypeId = option as int;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Seleccione un tipo de documento...',
                  labelText: 'Tipo documento',
                  errorText:
                      _documenTypeIdShowError ? _documenTypeIdError : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ));
  }

  Widget _showDocument() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _documentController,
        decoration: InputDecoration(
          hintText: 'Ingresa documento...',
          labelText: 'Documento',
          errorText: _documentShowError ? _documentError : null,
          suffixIcon: const Icon(Icons.assignment_ind),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _document = value;
        },
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: widget.user.id.isEmpty,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showAddress() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa direcci??n...',
          labelText: 'Direcci??n',
          errorText: _addressShowError ? _addressError : null,
          suffixIcon: const Icon(Icons.home),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _address = value;
        },
      ),
    );
  }

  Widget _showPhoneNumber() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Ingresa Tel??fono...',
          labelText: 'Tel??fono',
          errorText: _phoneNumberShowError ? _phoneNumberError : null,
          suffixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }

  Future<Null> _getDocumentTypes() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getDocumentTypes(widget.token);

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
      _documentTypes = response.result;
    });
  }

  List<DropdownMenuItem<int>> _getComboDocumentTypes() {
    List<DropdownMenuItem<int>> list = [];

    list.add(const DropdownMenuItem(
      child: Text('Seleccione un tipo de documento...'),
      value: 0,
    ));

    // ignore: avoid_function_literals_in_foreach_calls
    _documentTypes.forEach((documnentType) {
      list.add(DropdownMenuItem(
        child: Text(documnentType.description),
        value: documnentType.id,
      ));
    });

    return list;
  }

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                  camera: firstCamera,
                )));
    if (response != null) {
      setState(() {
        _PhotoChanged = true;
        _image = response.result;
      });
    }
  }
}
