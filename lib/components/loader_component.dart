import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  // ignore: use_key_in_widget_constructors
  const LoaderComponent({this.text = ''});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Center(
      // ignore: avoid_unnecessary_containers
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            Text(text, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
