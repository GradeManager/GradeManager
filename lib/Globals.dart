import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Map? Config;

bool isPluspoint = Config?["ispluspoints"] ?? false;

dynamic Rounding = Config?["rounding"] ?? 1;

//Grabs the DocumentDirectory
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
//Grabs Config file
Future<File> get _localFile async {
  final path = await _localPath;
  final file = File('$path/config.gm');

  if (!await file.exists()) {
    file.writeAsString(const JsonEncoder().convert(DefaultConfig));
  }

  return file;
}

Future<void> setConfig() async {
  final file = await _localFile;
  file.writeAsString(const JsonEncoder().convert(Config));
}

Future<bool> fetchConfig() async {
  try {
    final file = await _localFile;
    Config = const JsonDecoder().convert(await file.readAsString());
    return true;
  } catch (err) {
    return false;
  }
}

final DefaultConfig = {
  "semesters": {},
  "ispluspoints": false,
  "rounding": 1,
  "colorschema": DefColorSchema_ch.map((key, value) => MapEntry(key, value))
};

const DefColorSchema_gm = {
  "1-2": 4294047481,
  "2-3": 4288390325,
  "3-4": 4281944167,
  "4-5": 4280363582,
  "5-6": 4279834661
};

const DefColorSchema_ch = {
  "1-2": 16717846,
  "2-3": 16750121,
  "3-4": 16772664,
  "4-5": 4287349578,
  "5-6": 4283215696
};

const DefColorSchema_de = {
  "1-2": 4283215696,
  "2-3": 4287349578,
  "3-4": 16772664,
  "4-5": 16750121,
  "5-6": 16717846
};