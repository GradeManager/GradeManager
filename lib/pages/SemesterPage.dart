import 'package:flutter/material.dart';

import '../Globals.dart';

SnackBar? addItem(Map Parent, String Name, Object Body) {
  //This algorithmus is there to give a new item an alternative name
  //if the corresponding item already exists
  String tempName = Name;
  for (int i = 1; i<100; i++) {
    if (Parent[tempName]==null){
      break;
    }
    tempName = "$Name ${i.toString()}";
  }
  Parent.putIfAbsent(tempName, () => Body);
  setConfig();

  return SnackBar(
    backgroundColor: Colors.green,
    content: Text("Added: $Name"),
  );
}

SnackBar? removeItem(Map<dynamic, dynamic> Parent, String Name) {
  Parent.remove(Name);
  setConfig();
  return SnackBar(
    backgroundColor: Colors.orange,
    content: Text("Removed: $Name"),
  );
}

SnackBar? editItem(Map<dynamic, dynamic> Parent, String OldName, String NewName, String? NewPercentage) {
  dynamic tempNewVal;
  dynamic tempOldKey;

  //Fetch key
  Parent.entries.forEach((value) {
    if (value.key == OldName) {
      tempNewVal = value.value;
      tempOldKey = value.key;
    }
  });

  //Change percentage if required
  if (NewPercentage!=null) {
    if (Parent[OldName]["percentage"] == null) {
      Parent[OldName].putIfAbsent("percentage", () => double.parse(NewPercentage));
    } else {
      Parent[OldName]["percentage"] =
          double.parse(NewPercentage);
    }
  }

  //Check if old key is the same as new key, this occurs if someone only changes e.g. the percentage
  if (NewName==tempOldKey) {
    return NewPercentage==null ? null : SnackBar(
      backgroundColor: Colors.green,
      content: Text("Changed Percentage to: $NewPercentage"),
    );
  }

  if (Parent.containsKey(NewName)) {
    return const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Name already exists")
    );
  }

  //Remove old key and create new
  Parent.remove(tempOldKey);
  Parent.putIfAbsent(NewName, () => tempNewVal);
  setConfig();
  return SnackBar(
    backgroundColor: Colors.green,
    content: NewPercentage==null ? Text("Changed Name to: $NewName") : Text("Changed Name to: $NewName and Percentage to: $NewPercentage"),
  );
}