import 'package:GradeManager/pages/SemesterPage.SemesterList.dart';

import 'package:GradeManager/pages/HomePage.dart';
import 'package:GradeManager/pages/SettingsPage.dart';

import 'package:flutter/material.dart';

import 'Globals.dart';

void main() {
  runApp(const MyApp());
}

//MainWidget//----------------------------------------|
//MainWidget//----------------------------------------|
//MainWidget//----------------------------------------|

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  MaterialColor createCustomSwatch(Color color) {
    final swatch = <int, Color>{
      50: color.withOpacity(.1),
      100: color.withOpacity(.2),
      200: color.withOpacity(.3),
      300: color.withOpacity(.4),
      400: color.withOpacity(.5),
      500: color.withOpacity(.6),
      600: color.withOpacity(.7),
      700: color.withOpacity(.8),
      800: color.withOpacity(.9),
      900: color.withOpacity(1),
    };
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradeManager',
      theme: ThemeData(
        primarySwatch: createCustomSwatch(const Color.fromARGB(255, 20, 30, 48))
      ),
      home: const MainPage(title: 'GradeManager'),
    );
  }
}

//MainWidget//----------------------------------------|
//MainWidget//----------------------------------------|
//MainWidget//----------------------------------------|

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPage();
}


class _MainPage extends State<MainPage> {

  Widget _currentPage = home();

  int _currentIndex = 0;

  void _changeBNBItem(int index) {
    setState(() {
      switch (index) {
        case 0: _currentPage = home(); break;
        case 1: _currentPage = SemesterList(subItemName: "subjects", rewrapMainPage: () => setState(() {_currentIndex = 1;})); break;
        case 2: _currentPage = settings(); break;
      }
      _currentIndex = index;
    });
  }

  @override void initState() {
    super.initState();
    fetchConfig();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        enableFeedback: true,
        selectedItemColor: const Color.fromARGB(255, 20, 30, 48),
        currentIndex: _currentIndex,
        onTap: _changeBNBItem,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: 'Semester'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings'
          )
        ],
      ),
      body: _currentPage
    );
  }
}
