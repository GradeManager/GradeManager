import 'dart:convert';

import 'package:flutter/material.dart';

import '../Globals.dart';

class configEditor extends StatefulWidget {

  /// Config Editor Page
  ///
  /// Sideeffects:
  /// This Widget will only influence the config Object from the main.dart file
  const configEditor({super.key});

  State<configEditor> createState() => _configEditorState();
}

class _configEditorState extends State<configEditor> {

  TextEditingController configController = TextEditingController();

  @override
  void initState() {
    super.initState();
    configController.text = const JsonEncoder.withIndent(' ').convert(Config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              tooltip: "Discard changes",
              onPressed: () => {
                Navigator.pop(context)
              },
              child: const Icon(Icons.cancel_outlined, color: Colors.black)
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              tooltip: "Save changes",
              onPressed: () {
                try {
                  Config = const JsonDecoder().convert(configController.text);
                  setConfig();
                  Navigator.pop(context);
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Invalid JSON"),
                    ),
                  );
                }
              },
              child: const Icon(Icons.save, color: Colors.black)
          ),
        ],
      ),
      body: Theme(
        data: ThemeData(
          primaryColor: Colors.indigo,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 14, right: 14, top: 40, bottom: 100),
          child: TextField(
            controller: configController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: null,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: Colors.blue,

            expands: true,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            onChanged: (value) {
              if (value=="def") {
                configController.text = const JsonEncoder.withIndent(' ').convert(DefaultConfig);
              }
            },
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                hintText: 'Type "def" to generate empty config',
                hintStyle: TextStyle(color: Colors.white38)
            ),
          ),
        ),
      )
    );
  }
}