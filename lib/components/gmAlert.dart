import 'package:flutter/material.dart';

class gmAlert extends StatelessWidget {
  final String title;
  final double height;
  final Function() onSubmit;
  final Function() onCancel;
  final List<Widget> children;

  const gmAlert({required this.children, required this.onSubmit, required this.onCancel, required this.height, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      icon: const Icon(Icons.data_saver_off_sharp),
      title: Text(title),
      content: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          )
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 20, 30, 48)),
              ),
              onPressed: onCancel,
              label: const Text("Cancel"),
              icon: const Icon(Icons.cancel),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 20, 30, 48)),
            ),
            onPressed: onSubmit,
            label: const Text("Submit"),
            icon: const Icon(Icons.send),
          ),
        )
      ],
    );
  }
}