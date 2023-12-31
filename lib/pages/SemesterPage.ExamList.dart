import 'package:flutter/material.dart';

import '../Globals.dart';
import '../components/DreamGradeCalculator.dart';
import '../components/gmAlert.dart';
import '../components/gmItemContainer.dart';
import '../components/gmTextField.dart';
import 'SemesterPage.ExamPage.dart';
import 'SemesterPage.dart';

class ExamList extends StatefulWidget {
  final Map<dynamic, dynamic> itemInformation;
  final VoidCallback rewrapParent;
  final Map<dynamic, dynamic> itemParent;
  final String itemName;

  const ExamList({super.key,
    required this.itemInformation,
    required this.itemName,
    required this.rewrapParent,
    required this.itemParent});

  State<ExamList> createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  var examsList = <Widget>[];

  void rewrapList() {
    examsList.clear();

    if (widget.itemInformation.isEmpty) {
      return;
    }
    else {
      widget.itemInformation.forEach((key, value) {
        examsList.add(gmItemContainer(
          itemName: key,
          grade: value["grade"],
          icon: Icons.grade,
          parent: widget.itemInformation,
          rewrapParent: () => setState(() {
            rewrapList();
          }),
          removeItemFunc: removeItem,
          rounding: Rounding,
          child: ExamPage(
            exam: key,
            grade: value["grade"] ?? 0,
            percentage: value["percentage"] ?? 100,
            description: value["description"] ?? "",
            date: value["date"] ?? "",
            rewrapParent: () => setState(() {
              widget.rewrapParent();
              rewrapList();
            }),
            itemInformation: widget.itemInformation,
            setConfig: setConfig,
          ),
        ));
      });
    }
  }

  void openDreamGradeCalc() {
    double grade = double.nan;
    _dreamGradeController.text = "";
    _dreamPercentageController.text = "100";

    showDialog(
      context: context,
      builder: (context) => DreamGradeCalculator(dreamGradeController: _dreamGradeController,
        dreamPercentageController: _dreamPercentageController,
        grade: grade,
        itemInformation: widget.itemInformation,
      )
    );
  }

  void clearTextControllers() {
    _examNameController.text = "";
    _percentageController.text = "100";
    _gradeController.text = "4";
    _descriptionController.text = "";
  }

  final TextEditingController _examNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _subjectPercentageController = TextEditingController();

  final TextEditingController _dreamGradeController = TextEditingController();
  final TextEditingController _dreamPercentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rewrapList();
    _gradeController.text = "4";
    _percentageController.text = "100";
    _dreamPercentageController.text = "100";
    _subjectPercentageController.text = widget.itemParent[widget.itemName]["percentage"].toString();
    _subjectController.text = widget.itemName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: "Dream Grade",
            icon: const Icon(Icons.school),
            onPressed: () {
              openDreamGradeCalc();
            },
          ),
          IconButton(
            tooltip: "Edit Subject",
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => gmAlert(
                    title: "Edit ${widget.itemName}",
                    height: 175,
                    onSubmit: () {
                      final snackbar = editItem(widget.itemParent, widget.itemName, _subjectController.text,
                          widget.itemParent[widget.itemName]?["percentage"].toString() ==
                              _subjectPercentageController.text ? null : _subjectPercentageController.text);
                      if (snackbar != null) {
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }

                      Navigator.pop(context);
                      Navigator.pop(context);
                      //Rewrap self
                      setState(() {
                        rewrapList();
                      });
                      //Rewrap Parent
                      widget.rewrapParent();

                      _subjectPercentageController.text = (widget.itemParent[widget.itemName]?["percentage"] ?? 100).toString();
                      _subjectController.text = widget.itemName;
                    },
                    onCancel: () => {
                      Navigator.pop(context),
                      _subjectController.text = ""
                    },
                    children: [
                      gmTextField(
                        controller: _subjectController,
                        icon: Icons.send,
                        hintText: "Subject",
                        textAlign: TextAlign.left,
                        maxChars: 20,
                      ),
                      gmTextField(
                        controller: _subjectPercentageController,
                        icon: Icons.percent_rounded,
                        hintText: "Weight",
                        textAlign: TextAlign.left,
                        maxChars: 5,
                        textInputType: TextInputType.number,
                      )
                    ]
                  )
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 20, 30, 48),
        child: SingleChildScrollView(
          child: Column(
            children: examsList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => {
          showDialog(
              context: context,
              builder: (context) => gmAlert(
                  title: "Add Exam",
                  height: 350,
                  onSubmit: () {
                    final tmpGrade = double.tryParse(_gradeController.text);
                    final tmpPercentage = double.tryParse(_percentageController.text);
                    if (tmpGrade==null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter a grade"),
                            backgroundColor: Colors.red,
                          )
                      );
                      return;
                    } else if (tmpPercentage==null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter percentage"),
                            backgroundColor: Colors.red,
                          )
                      );
                      return;
                    }
                    Navigator.pop(context);
                    final snackbar = addItem(widget.itemInformation, _examNameController.text,
                        {
                          "grade": double.parse(_gradeController.text),
                          "percentage": double.parse(_percentageController.text),
                          "description": _descriptionController.text,
                          "date": "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"
                        }
                    );
                    if (snackbar!=null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    clearTextControllers();
                    setConfig();
                    //Rewrap self
                    setState(() {
                      rewrapList();
                    });
                    //Rewrap Parent
                    widget.rewrapParent();
                  },
                  onCancel: () => {
                    Navigator.pop(context),
                    clearTextControllers()
                  },
                  children: [
                    gmTextField(
                      controller: _examNameController,
                      icon: Icons.note,
                      hintText: "Name",
                      maxChars: 20,
                      textAlign: TextAlign.center,
                    ),
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
          )
        },
        child: const Icon(Icons.add_rounded, color: Colors.black),
      ),
    );
  }
}