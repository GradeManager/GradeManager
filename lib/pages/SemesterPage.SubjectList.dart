import 'package:flutter/material.dart';

import '../Globals.dart';
import '../components/gmAlert.dart';
import '../components/gmItemContainer.dart';
import '../components/gmTextField.dart';
import '../components/Math.dart';
import 'SemesterPage.ExamList.dart';
import 'SemesterPage.dart';

class SubjectList extends StatefulWidget {
  final Map<dynamic, dynamic> itemInformation;
  final VoidCallback rewrapParent;
  final String subItemName;
  final String itemName;

  const SubjectList({super.key,
    required this.itemInformation,
    required this.subItemName,
    required this.itemName,
    required this.rewrapParent});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {

  var subjectList = <Widget>[];

  void rewrapList() {
    subjectList.clear();

    if (widget.itemInformation.isEmpty) {
      return;
    }
    else {
      widget.itemInformation.forEach((key, value) {
        subjectList.add(gmItemContainer(
            itemName: key,
            grade: calcAverage(value[widget.subItemName]),
            icon: Icons.subject,
            parent: widget.itemInformation,
            rewrapParent: rewrapParent,
            removeItemFunc: removeItem,
            rounding: Rounding,
            child: ExamList(itemInformation: value[widget.subItemName],
                itemName: key, rewrapParent: rewrapParent,
                itemParent: widget.itemInformation
            )
        ));
      });
    }
  }

  rewrapParent() {
    setState(() {
      widget.rewrapParent();
      rewrapList();
    });
  }

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rewrapList();
    _semesterController.text = widget.itemName;
    _percentageController.text = "100";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      appBar: AppBar(
        title: Text(widget.itemName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => gmAlert(
                      title: "Edit ${widget.itemName}",
                      height: 95,
                      onSubmit: () {
                        final snackBar = editItem(Config!["semesters"], widget.itemName, _semesterController.text, null);
                        if (snackBar != null) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                        //Rewrap self
                        rewrapParent();
                        //Rewrap Parent
                        widget.rewrapParent();

                        _semesterController.text = widget.itemName;
                      },
                      onCancel: () => {
                        Navigator.pop(context),
                        _semesterController.text = widget.itemName,
                      },
                      children: [
                        gmTextField(
                          controller: _semesterController,
                          icon: Icons.send,
                          hintText: "New Semestername",
                          textAlign: TextAlign.left,
                          maxChars: 20,
                        ),
                      ]
                  )
              );
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 20, 30, 48),
        child: SingleChildScrollView(
          child: Column(
            children: subjectList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => {
          showDialog(
              context: context,
              builder: (context) => gmAlert(
                  title: "Add Subject",
                  height: 165,
                  onSubmit: () {
                    Navigator.pop(context);
                    final snackbar = addItem(widget.itemInformation, _subjectController.text,
                        {"exams":{}, "percentage": double.parse(_percentageController.text)}
                    );
                    if (snackbar!=null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    setConfig();
                    //Rewrap self
                    rewrapParent();
                    //Rewrap Parent
                    widget.rewrapParent();
                    _subjectController.text = "";
                    _percentageController.text = "100";
                  },
                  onCancel: () {
                    Navigator.pop(context);
                    _subjectController.text = "";
                    _percentageController.text = "100";
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
                      controller: _percentageController,
                      icon: Icons.percent_rounded,
                      hintText: "Percentage",
                      textAlign: TextAlign.left,
                      maxChars: 5,
                      textInputType: TextInputType.number,
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