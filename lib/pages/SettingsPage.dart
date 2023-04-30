import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GradeManager/pages/SemesterPage.dart';
import 'package:GradeManager/pages/SettingsPage.ConfigEditor.dart';
import 'package:GradeManager/pages/SettingsPage.ColorEditor.dart';

import 'package:GradeManager/components/ConfigParser.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Globals.dart';

class settings extends StatefulWidget {

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {

  int _gradeformatState = 1;
  int _roundingState = 1;

  void setGradeFormatState(int value) {
    setState(() {
      if (value == 1) {
        Config!["ispluspoints"] = false;
        setConfig();
      } else if (value == 2) {
        Config?["ispluspoints"] = true;
        setConfig();
      }
    });
  }

  void setRoundingState(int value) {
    setState(() {
      Config?["rounding"] = value;
      setConfig();
    });
  }

  void initRadioStates() {
    isPluspoint = Config?["ispluspoints"] ?? false;
    Rounding = Config?["rounding"] ?? 1;
    if (isPluspoint) {
      _gradeformatState = 2;
    } else {
      _gradeformatState = 1;
    }

    try {
      _roundingState=Rounding;
    } catch (err) {
      //Self heal config
      Config?["rounding"] = 1;
      setConfig();
      Rounding = Config?["rounding"];
      _roundingState=Rounding;
    }
  }

  Future<String?> fetchExternalConfig() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null){
      return null;
    }
    try {
      final path = result.files.single.path;
      final file = File(path!);
      final contents = await file.readAsString();
      return contents;
    } catch (err) {
      //If not a string, then an error occurred while reading the file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(err.toString())
        )
      );
      return null;
    }
  }

  /// Imports a configuration
  ///
  /// Step 1: Opens a File Browser to select a file.
  ///
  /// Step 2: Parse the file with the provided parser.
  ///
  /// Step 3: Write file to the current configuration.
  ///
  /// [parser] Parser function, needs to take the raw string as only argument and return the parsed config
  Future<void> importConfig(BuildContext context, Function parser) async {
    Future<bool> showImportDialog(Map parsedContent) async {
      Completer<bool> completer = Completer<bool>();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Import Config"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("This is a non destructive action!",
                style: TextStyle(color: Colors.orange),
                textAlign: TextAlign.center),
              Text("Your current configuration\n will not be damaged",
                textAlign: TextAlign.center),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                completer.complete(false);
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.red),
              ),
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel")),
            ElevatedButton.icon(
              onPressed: () {
                parsedContent.forEach((key, value) {
                  addItem(Config!["semesters"], key, value);
                });
                Navigator.pop(context);
                completer.complete(true);
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.green),
              ),
              icon: const Icon(Icons.import_export),
              label: const Text("Import"))
          ],
          actionsAlignment: MainAxisAlignment.center,
        ));

      return completer.future;
    }

    SnackBar? snackbar;

    try {
      final tmpConf = await fetchExternalConfig();
      if (tmpConf != null) {
        if (await showImportDialog(parser(tmpConf))) {
          snackbar = const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Successfully imported configuration")
          );
        }
      }
    } catch (err) {
      snackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(err.toString())
      );
    } finally {
      if (snackbar!=null) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  /// Exports Config
  ///
  /// Throws an error if it fails
  Future<void> exportConfig() async {
    final path = await FilePicker.platform.getDirectoryPath();

    if (path == null) {
      return;
    }
    final file = File('$path/config.gm');
    file.create(recursive: true);
    await file.writeAsString(const JsonEncoder().convert(Config));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> url(String uri) async {
      if (!await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cannot open URL"),
            backgroundColor: Colors.red,
          )
        );
      }
    }

    Widget buttonBlock({required Function onPressed, required Widget icon, required Text label}) {
      return Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: ElevatedButton.icon(
          style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(290, 40)), alignment: Alignment.centerLeft),
          onPressed: () {
            onPressed();
          },
          icon: icon,
          label: label,
        )
      );
    }

    SizedBox marginBlock = const SizedBox(
      height: 15,
    );

    initRadioStates();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            section(
              title: "General",
              Subitems: [
                const Text("Grade format", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),
                RadioListTile(
                  title: const Text("Classic Grades", style: TextStyle(fontSize: 15)),
                  value: 1,
                  groupValue: _gradeformatState,
                  onChanged: (val) {
                    setGradeFormatState(int.parse(val.toString()));
                  },
                ),
                RadioListTile(
                  title: const Text("PlusPoints", style: TextStyle(fontSize: 15)),
                  value: 2,
                  groupValue: _gradeformatState,
                  onChanged: (val) {
                    setGradeFormatState(int.parse(val.toString()));
                  }
                ),

                const Text("Displayed Rounding", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),
                RadioListTile(
                  title: const Text("Standard", style: TextStyle(fontSize: 15)),
                  value: 1,
                  groupValue: _roundingState,
                  onChanged: (val) {
                    setRoundingState(int.parse(val.toString()));
                  },
                ),
                RadioListTile(
                  title: const Text("0.25", style: TextStyle(fontSize: 15)),
                  value: 2,
                  groupValue: _roundingState,
                  onChanged: (val) {
                    setRoundingState(int.parse(val.toString()));
                  }
                ),
                RadioListTile(
                  title: const Text("0.5", style: TextStyle(fontSize: 15)),
                  value: 3,
                  groupValue: _roundingState,
                  onChanged: (val) {
                    setRoundingState(int.parse(val.toString()));
                  }
                ),
              ]
            ),
            section(
              title: "Import/Export",
              Subitems: [
                const Text("Import", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),
                buttonBlock(
                  onPressed: () async {
                    await importConfig(context, parseGradeManager);
                  },
                  icon: const Icon(Icons.file_open),
                  label: const Text("Import Config from GradeManager")
                ),
                buttonBlock(
                  onPressed: () async {
                    await importConfig(context, parseLegacy);
                  },
                  icon: const Icon(Icons.file_open_outlined),
                  label: const Text("Import from Legacy Grademanager")
                ),
                buttonBlock(
                  onPressed: () async {
                    await importConfig(context, parsePlusPoints);
                  },
                  icon: const Icon(Icons.add_circle),
                  label: const Text("Import Config from PlusPoints")
                ),

                const Text("Export", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),

                buttonBlock(
                  onPressed: () async {
                    try {
                      await exportConfig();
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(err.toString())
                        )
                      );
                    }
                  },
                  icon: const Icon(Icons.import_export),
                  label: const Text("Export Config")
                ),
              ]
            ),
            section(
              title: "Advanced",
              Subitems: [
                const Text("Configuration", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),

                buttonBlock(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const configEditor()));
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit configuration")
                ),
                buttonBlock(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const colorEditor()));
                  },
                  icon: const Icon(Icons.color_lens_outlined),
                  label: const Text("Edit Colorscheme")
                ),
              ],
            ),
            section(
              title: "About",
              Subitems: [
                const Text("Legal", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),

                buttonBlock(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LicensePage(
                      applicationIcon: ImageIcon(
                        AssetImage("assets/icons/GM_white.png"),
                        color: Colors.black,
                        size: 80,
                      ),
                    )));
                  },
                  icon: const Icon(Icons.balance_rounded),
                  label: const Text("Licenses")
                ),

                const Text("Contact", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                const Divider(color: Colors.black, thickness: 0.2),

                buttonBlock(
                  onPressed: () async {
                    await url("https://github.com/GradeManager/GradeManager");
                  },
                  icon: const Icon(Icons.code_rounded),
                  label: const Text("Code on Github")
                ),
                buttonBlock(
                    onPressed: () async {
                      await url("https://github.com/GradeManager/GradeManager/issues/new");
                    },
                    icon: const Icon(Icons.error_outline_rounded),
                    label: const Text("Open Issue on Github")
                ),
                buttonBlock(
                  onPressed: () async {
                    await url("https://grademanager.megakuul.ch");
                  },
                  icon: const ImageIcon(AssetImage("assets/icons/GM_white.png")),
                  label: const Text("Website")
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}

class section extends StatelessWidget {

  final String title;
  final List<Widget> Subitems;

  const section({required this.title, required this.Subitems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Subitems,
          ),
        ),
        const Divider(color: Colors.black)
      ]
    );
  }
}