import 'dart:convert';
import 'package:xml/xml.dart';

/// Parses the Configuration from the GradeManager
///
/// Takes the configuration as argument and returns the GradeManager Config
Map parseGradeManager(String GradeManagerConfig) {
  Map<dynamic, dynamic> originalConf = const JsonDecoder().convert(GradeManagerConfig);
  Map<String, dynamic> tmpConf = {};

  if (originalConf["semesters"]==null) {
    throw Exception("Parser didnt found semesters in config");
  }

  originalConf["semesters"].forEach((key, value) {
    tmpConf.putIfAbsent(key, () => value);
  });

  return tmpConf;
}

/// Parses the Configuration from the Legacy GradeManager
///
/// Takes the configuration as argument and returns the GradeManager Config
Map parseLegacy(String LegacyConfig) {
  Map<dynamic, dynamic> originalConf = const JsonDecoder().convert(LegacyConfig);
  Map<String, dynamic> tmpConf = {};

  tmpConf.putIfAbsent("Legacy Semester", () => {"subjects":{}});

  originalConf["subjects"].forEach((key, value) {
    tmpConf["Legacy Semester"]["subjects"].putIfAbsent(key, () {
      Map<String, dynamic> tmpExams = {};

      value.forEach((exKey, exVal) {
        tmpExams.putIfAbsent(exKey, () => {
          "grade": exVal["grade"],
          "percentage": exVal["percentage"].toDouble(),
          "date": exVal["date"]
        });
      });

      return {
        "exams": tmpExams,
        "percentage": 100.0
      };
    });
  });

  return tmpConf;
}

/// Parses the Configuration from the PlusPoint App
///
/// Takes the configuration as argument and returns the GradeManager Config
Map parsePlusPoints(String PlusPointConfig) {
  const pp_name = "name";
  const pp_semester = "Semester";
  const pp_subjects = "subjects";
  const pp_exams = "exams";
  const pp_percentage = "weight";
  const pp_grade = "mark";

  const gm_subjects = "subjects";
  const gm_exams = "exams";
  const gm_percentage = "percentage";
  const gm_grade = "grade";
  const gm_description = "description";
  const gm_date = "date";

  XmlElement getValueForKey(XmlElement element, String keyName) {
    final XmlElement keyElement = element.findElements('key').firstWhere(
        (key) => key.text == keyName,
        orElse: () {
          throw Exception("Cannot find Key: $keyName in element ${element.name}");
        },
    );
    return keyElement.nextElementSibling!;
  }

  // XMLify the Document
  final ogDoc = XmlDocument.parse(PlusPointConfig);

  // Fetch the top layer with the Metadata
  final ogMetaDict = ogDoc
      .findAllElements("dict")
      .firstWhere((dict) => dict
      .findAllElements('key')
      .any((key) => key.text == 'data'));

  // Fetch the second layer with the Semesterinformation
  final ogSemDict = ogMetaDict
      .findAllElements("dict")
      .firstWhere((dict) => dict
        .findAllElements('key')
        .any((key) => key.text == 'class' && key.nextElementSibling?.text == pp_semester));

  Map<String, dynamic> tmpConf = {};

  // Add the Semester to the tempConf
  final semesterName = getValueForKey(ogSemDict, pp_name).text;
  // Create the Subject Array
  tmpConf.putIfAbsent(semesterName, () => {gm_subjects:{}});

  // Fetch the Subject Array Object from the Semester Object
  final subjectArray = getValueForKey(ogSemDict, pp_subjects);


  // Iterate over all Subjects
  subjectArray.findElements("dict").forEach((subjectDict) {

    final subjectsConf = tmpConf[semesterName][gm_subjects];
    // Get Name of the Subject
    final subjectName = getValueForKey(subjectDict, pp_name).text;
    // Create the Subject object
    subjectsConf.putIfAbsent(subjectName, () => {});
    // Try to parse weight
    final subjectPercentage = double.tryParse(getValueForKey(subjectDict, pp_percentage).text);
    if (subjectPercentage==null) {
      throw Exception("Cannot parse weight/percentage of subject: $subjectName");
    }
    // Add the percentage to the object
    subjectsConf[subjectName].putIfAbsent(gm_percentage, () => subjectPercentage.toDouble() * 100.0);

    // Create the Exam Array
    subjectsConf[subjectName].putIfAbsent(gm_exams, () => {});

    // Fetch the Exam Array Object from the Subject Object
    final examArray = getValueForKey(subjectDict, pp_exams);

    // Iterate over all exames
    examArray.findElements("dict").forEach((examDict) {
      final examsConf = subjectsConf[subjectName][pp_exams];
      // Get Name of the Exam
      final examName = getValueForKey(examDict, pp_name).text;
      // Create the Exam object
      examsConf.putIfAbsent(examName, () => {});

      // Try to parse percentage
      final double? examPercentage = double.tryParse(getValueForKey(examDict, pp_percentage).text);
      if (examPercentage==null) {
        throw Exception("Cannot parse weight/percentage of exam: $examName");
      }
      // Add the percentage to the object
      examsConf[examName].putIfAbsent(gm_percentage, () => examPercentage * 100.0);

      // Try to parse grade
      final double? examGrade = double.tryParse(getValueForKey(examDict, pp_grade).text);
      if (examGrade==null) {
        throw Exception("Cannot parse grade/mark of exam: $examName");
      }
      // Add the grade to the object
      examsConf[examName].putIfAbsent(gm_grade, () => examGrade);

      // Add the description to the object
      examsConf[examName].putIfAbsent(gm_description, () => " ");
      // Add the date to the object
      // TODO: Read Date from the Pluspoint config if possible
      examsConf[examName].putIfAbsent(gm_date, () => "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    });
  });

  return tmpConf;
}