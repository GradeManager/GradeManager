/// Calculates Average of all parent elements
///
///
/// It searchs for the "grade" and the "percentage" value in the elements of
/// the parent and calculates the average
///
///
/// Calculation:
///
/// ```
/// The Average is calculated by Summing all elements and then divide
/// them with the number of the elements. E.g. (1,2,3) -> (1+2+3) / 3
/// ```
/// [Return] Result as a double
double calcAverage(Map<dynamic, dynamic> parent) {
  double tempGrade = 0;
  double tempPercentage = 0;

  parent.forEach((key, value) {
    try {
      double grade = value["grade"];
      if (!grade.isNaN) {
        double percentage = value["percentage"]??100;
        tempGrade += grade * percentage;
        tempPercentage += percentage;
      }
    } catch (err){}
  });
  double result = tempGrade / tempPercentage;
  if (result.isNaN) {
    return double.nan;
  } else {
    return result;
  }
}

/// Calculates the grade you need to get the defined average
///
///
/// It calculates the average of the parent object and extracts the
/// grade you need to get the dreamGrade/dream average
///
///
/// Calculation:
///
/// ```
/// The grade you need to get the dreamGrade/dream average is calculated by
/// multiplying the current average with the number of elements from the current list,
/// then calculating the average the user wants to have by multiplying the dreamGrade/dream average
/// with the number of elements from the current list + 1. The final average gets
/// extracted by subtracting the second result from the first result.
/// E.g. current average = 4
///      desired average (dreamgrade) = 5
///      -> Result is 5 * desired.entries - 4 * current.entries
/// ```
/// [Return] Result as a double
double calcDreamGrade(Map<dynamic, dynamic> parent, double dreamGrade, double percentage) {
  double beforAverage = calcAverage(parent) * (parent.length);

  double desiredAverage = dreamGrade * (parent.length + 1);

  double weight = (percentage / 100);

  return (desiredAverage - beforAverage) /  weight;
}

/// Calculates Average of all subitems of an item
///
///
/// It searchs for the "grade" and the "percentage" value in the elements of the parents subelement
///
///
/// Calculation:
///
/// ```
/// The Average is calculated by Summing all elements and then divide
/// them with the number of the elements. E.g. (1,2,3) -> (1+2+3) / 3
/// ```
/// [Return] Result as a double
double calcAverageOfAverage(Map<dynamic, dynamic> parent, String calcAverageOf) {
  //Calc semester average
  double tempGrade = 0;
  double tempPercentage = 0;

  parent.forEach((key, value) {
    try {
      double grade = calcAverage(value[calcAverageOf]);
      if (!grade.isNaN) {
        double percentage = value["percentage"]??100;
        tempGrade += grade * percentage;
        tempPercentage += percentage;
      }
    } catch (err){
      //Errors aren't there to be catched...
      //~ Mr. Meister
    }
  });
  double result = tempGrade / tempPercentage;
  if (result.isNaN) {
    return double.nan;
  } else {
    return result;
  }
}

/// Calculates Pluspoints of all parent elements
///
///
/// It searchs for the "grade" and the "percentage" value in the elements of the parents subelement
///
///
/// Calculation:
///
/// ```
/// PlusPoints are calculated by following steps:
/// First this calculates the average for each subitem,
/// then if the grade is lower than 3.75 it will multiply the grade with
/// 2 and subtract 8 from the result, if the grade is higher than 3.75 it will
/// just subtract the grade by 4.
/// In the end the points are rounded to the nearest quarter.
///
/// With that System grades above 3.75 count normal while grades below 3.75 will
/// have the doubled weight.
/// ```
/// [Return] Result as a double
double getPlusPoints(Map<dynamic, dynamic> parent, String calcAverageOf) {
  //Calc semester average
  double tempPoints = 0;

  parent.forEach((key, value) {
    try {
      double grade = calcAverage(value[calcAverageOf]);
      double percentage = value["percentage"]??100;
      if (grade < 3.75) {
        tempPoints += (roundToNearestHalf(grade) * 2 -8) * percentage;
      } else {
        tempPoints += (roundToNearestHalf(grade) -4) * percentage;
      }
    } catch (err){
      //Best practise to catch an error is to tell a joke:
      //Why is a banana round? because of bread! (audience laughter)
    }
  });
  double result = tempPoints / 100;
  if (result.isNaN) {
    return double.nan;
  } else {
    return result;
  }
}

/// Calculates Pluspoints of all subitems of the config
///
///
/// It searchs for the "grade" and the "percentage" value in the elements of the configs subelements
///
/// [Return] Result as a double
double getSumPluspoints(Map<dynamic, dynamic>? config) {
  double tempPoints = 0;

  config?["semesters"].forEach((key, value) {
    tempPoints += getPlusPoints(value["subjects"], "exams");
  });

  if (tempPoints.isNaN) {
    return double.nan;
  } else {
    return tempPoints;
  }
}

/// Calculates Average of all subitems of the config
///
///
/// It searchs for the "grade" and the "percentage" value in the elements of the configs subelements
///
///
/// Calculation:
///
/// ```
/// The Average is calculated by Summing all elements and then divide
/// them with the number of the elements. E.g. (1,2,3) -> (1+2+3) / 3
/// ```
/// [Return] Result as a double
double getSumGrade(Map<dynamic, dynamic>? config) {
  double tempGrade = 0;
  int i = 0;

  if (config == null || config["semesters"] == null) {
    return double.nan;
  }

  config["semesters"].forEach((key, value) {
    try {
      double grade = calcAverageOfAverage(value["subjects"], "exams");
      if (!grade.isNaN) {
        tempGrade += grade;
        i++;
      }
    } catch (err){
      //Salad is very healthy
    }
  });
  double result = tempGrade / i;
  if (result.isNaN) {
    return double.nan;
  } else {
    return result;
  }
}

/// Rounds a Number to the nearest half
///
/// [Return] Result as a double
double roundToNearestHalf(double value) {
  return (value * 2).round() / 2;
}

/// Rounds a Number to the desired rounding
///
/// Rounding States:
/// 1: Dont Round
/// 2: Round to 0.25
/// 3: Round to 0.5
///
/// [Return] Result as a double
double roundToDesired(double value, int roundingState) {
  if (roundingState==2) {
    //Round to 0.25
    return (value * 4).round() / 4;
  } else if (roundingState==3) {
    //Round to 0.5
    return (value * 2).round() / 2;
  } else {
    return value;
  }
}