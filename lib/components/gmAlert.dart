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
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        ElevatedButton.icon(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color:Colors.deepPurple)
              )
            ),
          ),
          onPressed: onCancel,
          label: const Text("Cancel"),
          icon: const Icon(Icons.cancel),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color:Colors.deepPurple)
                )
            ),
          ),
          onPressed: onSubmit,
          label: const Text("Submit"),
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}