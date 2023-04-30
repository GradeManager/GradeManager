import 'package:flutter/material.dart';

import '../Globals.dart';
import '../components/gmAlert.dart';
import '../components/gmItemContainer.dart';
import '../components/gmTextField.dart';
import '../components/Math.dart';
import 'SemesterPage.SubjectList.dart';
import 'SemesterPage.dart';

class SemesterList extends StatefulWidget {
  final String subItemName;
  final VoidCallback rewrapMainPage;

  const SemesterList({required this.subItemName, required this.rewrapMainPage});

  @override
  State<SemesterList> createState() => _SemesterListState();
}

class _SemesterListState extends State<SemesterList> {

  var semesterList = <Widget>[];

  void rewrapList() {

    semesterList.clear();
    if (Config!["semesters"]==null) {
      return;
    }

    if (Config!["semesters"].isEmpty) {
      return;
    }
    else {
      Config!["semesters"].forEach((key, value) {
        semesterList.add(gmItemContainer(
            itemName: key,
            grade: isPluspoint ? getPlusPoints(value[widget.subItemName], "exams"): calcAverageOfAverage(value[widget.subItemName], "exams"),
            icon: Icons.bar_chart_rounded,
            parent: Config!["semesters"],
            rewrapParent: rewrapParentTree,
            removeItemFunc: removeItem,
            rounding: Rounding,
            child: SubjectList(itemInformation: value[widget.subItemName],
                itemName: key, subItemName: "exams",
                rewrapParent: rewrapParentTree
            )
        ));
      });
    }
  }

  void rewrapParentTree() {
    setState(() {
      widget.rewrapMainPage();
      rewrapList();
    });
  }

  TextEditingController semesterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isPluspoint = Config!["ispluspoints"] ?? false;
    rewrapList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 48),
      appBar: AppBar(
        title: const Text("Semesters"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height-kBottomNavigationBarHeight,
        child: SingleChildScrollView(
          child: Column(
            children: semesterList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => {
          showDialog(
              context: context,
              builder: (context) => gmAlert(
                  title: "Add Semester",
                  height: 80,
                  onSubmit: () {
                    Navigator.pop(context);
                    final snackbar = addItem(Config!["semesters"], semesterController.text, {"subjects":{}});
                    if (snackbar!=null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    semesterController.text = "";
                    rewrapParentTree();
                  },
                  onCancel: () => {
                    Navigator.pop(context),
                    semesterController.text = ""
                  },
                  children: [
                    gmTextField(
                      controller: semesterController,
                      icon: Icons.send,
                      hintText: "Semester",
                      textAlign: TextAlign.left,
                      maxChars: 20,
                    ),
                  ]
              )
          )
        },
        child: const Icon(Icons.add_rounded, color: Colors.black),
      ),
    );
  }
}