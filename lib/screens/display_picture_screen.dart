// ignore_for_file: use_key_in_widget_constructors, empty_constructor_bodies, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vista previa de la foto'),
        ),
        body: Image.file(File(widget.imagePath)));
  }
}
