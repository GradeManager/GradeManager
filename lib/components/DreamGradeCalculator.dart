import 'package:GradeManager/Globals.dart';
import 'package:flutter/material.dart';

import 'gmTextField.dart';
import 'Math.dart';

class DreamGradeCalculator extends StatefulWidget {
  DreamGradeCalculator({
    Key? key,
    required this.dreamGradeController,
    required this.dreamPercentageController,
    required this.grade,
    required this.itemInformation,
  }) : super(key: key);

  final TextEditingController dreamGradeController;
  final TextEditingController dreamPercentageController;
  double grade;
  final Map<dynamic, dynamic> itemInformation;

  @override
  _DreamGradeCalculatorState createState() => _DreamGradeCalculatorState();
}

class _DreamGradeCalculatorState extends State<DreamGradeCalculator> {

  double getDreamGrade(TextEditingController gradeController, TextEditingController percentageController) {
    return calcDreamGrade(widget.itemInformation,
      double.tryParse(gradeController.text) ?? double.nan,
      double.tryParse(percentageController.text) ?? double.nan
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      icon: const Icon(Icons.school),
      title: const Text("Dream Grade"),
      content: SizedBox(
        height: 235,
        child: SingleChildScrollView(
          child: Column(
            children: [
              gmTextField(
                controller: widget.dreamGradeController,
                icon: Icons.grade_outlined,
                hintText: "Dream Grade",
                textAlign: TextAlign.left,
                maxChars: 3,
                textInputType: TextInputType.number,
                onChanged: (input) {
                  widget.grade = getDreamGrade(widget.dreamGradeController, widget.dreamPercentageController);
                  setState(() {});
                },
              ),
              gmTextField(
                controller: widget.dreamPercentageController,
                icon: Icons.percent_rounded,
                hintText: "Weight",
                textAlign: TextAlign.left,
                maxChars: 5,
                textInputType: TextInputType.number,
                onChanged: (input) {
                  widget.grade = getDreamGrade(widget.dreamGradeController, widget.dreamPercentageController);
                  setState(() {});
                },
              ),
              const Text("Required Grade", style: TextStyle(fontSize: 15)),
              Text(widget.grade.toStringAsFixed(2), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
