import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../Globals.dart';

class colorEditor extends StatefulWidget {

  /// Color Editor Page
  ///
  /// Sideeffects:
  /// This Widget will only influence the config Object from the main.dart file
  const colorEditor({super.key});

  State<colorEditor> createState() => _colorEditorState();
}

class _colorEditorState extends State<colorEditor> {

  Future<Color?> _openColorPicker(Color currentColor) async {
    Color _currentColor = currentColor;

    return await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 20, 30, 48),
          title: const Text('Pick a color', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                _currentColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              portraitOnly: true,
              displayThumbColor: true,
              paletteType: PaletteType.hueWheel,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(_currentColor);
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> getColorSchema(Map<String, dynamic>? config) {
    try {
      if (config==null) {
        throw Exception();
      }

      List<Widget> tempList = [];

      double i = 1;

      config.forEach((key, value) {
        if (i>6) {
          return;
        }

        tempList.add(
          Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton.icon(
                onPressed: () async {
                  config[key] = (await _openColorPicker(Color(config[key])))?.value ?? value;
                  setConfig();
                  setState(() {});
                },
                style: ButtonStyle(
                  fixedSize: const MaterialStatePropertyAll(Size(400, 70)),
                  // Add up the Alpha value with the OR operator
                  backgroundColor: MaterialStatePropertyAll(Color(config[key] | 0xFF000000))
                ),
                icon: const Icon(Icons.format_paint),
                label: Text(key)
            ),
          )
        );
      });

      return tempList;
    } catch (err) {
      return [
        SimpleDialog(
          title: const Text("Error", textAlign: TextAlign.center),
          children: [
            const Text("Color Config is corrupted", textAlign: TextAlign.center),
            const SizedBox(
              height: 30,
            ),
            Text("Error: $err", textAlign: TextAlign.center, style: const TextStyle(fontSize: 9),)
          ],
        )
      ];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 1200,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            children: getColorSchema(Config?["colorschema"]),
          ),
        )
      ),
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 20, 30, 48),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Color Editor"),
        centerTitle: true,
        actions: [
          PopupMenuButton<Map<String, dynamic>>(
            color: const Color.fromARGB(255, 20, 30, 48),
            tooltip: "Predefined Schemas",
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (Map<String, dynamic> conf) {
              Config?["colorschema"] = conf.map((key, value) => MapEntry(key, value));
              setConfig();
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<Map<String, dynamic>>(
                  value: DefColorSchema_gm,
                  child: Text('GM Layout', style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem<Map<String, dynamic>>(
                  value: DefColorSchema_ch,
                  child: Text('CH Layout', style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem<Map<String, dynamic>>(
                  value: DefColorSchema_de,
                  child: Text('DE Layout', style: TextStyle(color: Colors.white)),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}