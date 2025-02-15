import 'dart:convert';
import 'dart:io';

void appendStringToArbFile(String fileName, String name, String text) {
  final file = File(fileName);
  final arbObj = readArbFile(file);

  if (arbObj.containsKey(name)) {
    print("String $name already exists in $fileName!");
    return;
  }

  arbObj.addAll({name: text});

  final outputContent = json
      .encode(arbObj)
      .replaceAll('","', '",\n  "')
      .replaceAll('{"', '{\n  "')
      .replaceAll('"}', '"\n}')
      .replaceAll('":"', '": "');

  file.writeAsStringSync(outputContent);
}

void appendStringsToArbFile(String fileName, Map<String, String> strings) {
  final file = File(fileName);
  final arbObj = readArbFile(file);

  arbObj.addAll(strings);

  final outputContent = json
      .encode(arbObj)
      .replaceAll('","', '",\n  "')
      .replaceAll('{"', '{\n  "')
      .replaceAll('"}', '"\n}')
      .replaceAll('":"', '": "');

  file.writeAsStringSync(outputContent);
}

Map<String, dynamic> readArbFile(File file) {
  final inputContent = file.readAsStringSync();

  return json.decode(inputContent) as Map<String, dynamic>;
}

String getArbFileName(String lang) {
  final shortLang = lang
      .split("-")
      .first;
  return "./res/values/strings_$shortLang.arb";
}

List<String> getMissingKeysInArbFile(String fileName, Iterable<String> langKeys) {
  final file = File(fileName);
  final arbObj = readArbFile(file);
  final results = <String>[];

  for (var langKey in langKeys) {
    if (!arbObj.containsKey(langKey)) {
      results.add(langKey);
    }
  }

  return results;
}
