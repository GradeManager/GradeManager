import 'package:flutter/material.dart';

import 'package:GradeManager/components/gmAlert.dart';
import 'package:GradeManager/components/gmGauge.dart';
import 'package:GradeManager/components/gmTextField.dart';

import '../Globals.dart';

class ExamPage extends StatelessWidget {
  final String exam;
  final double grade;
  final String date;
  final double percentage;
  final String description;
  final VoidCallback rewrapParent;
  final Function setConfig;
  final Map<dynamic, dynamic> itemInformation;

  ExamPage({required this.exam, required this.grade, required this.percentage, required this.description, required this.date, required this.rewrapParent, required this.itemInformation, required this.setConfig});

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();

  resetControllers() {
    _descriptionController.text = description;
    _gradeController.text = grade.toString();
    _percentageController.text = percentage.toString();
  }

  @override
  Widget build(BuildContext context) {
    resetControllers();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              mini: true,
              heroTag: null,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.cancel_outlined),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              mini: true,
              heroTag: null,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => gmAlert(
                        title: "Edit $exam",
                        height: 240,
                        onSubmit: () {
                          try {
                            itemInformation[exam]["grade"] = double.parse(_gradeController.text);
                            itemInformation[exam]["percentage"] = double.parse(_percentageController.text);
                            itemInformation[exam]["description"] = _descriptionController.text;

                            setConfig();
                            rewrapParent();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$err"),
                                  backgroundColor: Colors.red,
                                )
                            );
                          }
                        },
                        onCancel: () => {
                          Navigator.pop(context),
                          resetControllers()
                        },
                        children: [
                          gmTextField(
                            controller: _gradeController,
                            icon: Icons.grade_rounded,
                            textAlign: TextAlign.center,
                            maxChars: 3,
                            textInputType: TextInputType.number,
                            hintText: "Grade",
                          ),
                          gmTextField(
                            controller: _percentageController,
                            icon: Icons.percent_rounded,
                            textAlign: TextAlign.center,
                            maxChars: 5,
                            textInputType: TextInputType.number,
                            hintText: "Percentage",
                          ),
                          gmTextField(
                            controller: _descriptionController,
                            icon: Icons.description,
                            hintText: "Description",
                            maxChars: 100,
                            textAlign: TextAlign.center,
                          )
                        ]
                    )
                );
              },
              child: const Icon(Icons.edit),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: Text(
                      exam,
                      style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center
                  ),
                ),
                SizedBox(
                  height: 240,
                  child: gmGauge(grade: grade, scale: 1.3, config: Config),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.date_range_outlined, color: Colors.white,size: 25),
                      Text(" $date", style: const TextStyle(color: Colors.white, fontSize: 25)),
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  constraints: const BoxConstraints(
                      maxWidth: 400
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    readOnly: true,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: null,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.white38)
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}